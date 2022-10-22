import 'dart:typed_data';

import 'package:aladagram/models/postmodel.dart';
import 'package:aladagram/resources/storage_method.dart';
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
}
