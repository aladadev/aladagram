import 'dart:typed_data';

import 'package:aladagram/models/postmodel.dart';
import 'package:aladagram/resources/storage_method.dart';
import 'package:aladagram/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String result = 'some error occured while posting';
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          postUrl: photoUrl,
          profImage: profImage,
          datePublished: DateTime.now(),
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      result = 'Success';
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('No comment text is empty niggas');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> followUser(String uid, String followID) async {
    try {
      var snap = await _firestore.collection('users').doc(uid).get();
      List following = snap.data()!['following'];
      if (following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID]),
        });
      } else {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID]),
        });
      }
    } catch (e) {
      print('problem with firestore method followuser');
    }
  }
}
