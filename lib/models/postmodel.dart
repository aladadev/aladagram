// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List likes;
  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.postUrl,
    required this.profImage,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'uid': uid,
      'username': username,
      'postId': postId,
      'postUrl': postUrl,
      'profImage': profImage,
      'datePublished': datePublished,
      'likes': likes,
    };
  }

  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post(
        description: snap['description'] as String,
        uid: snap['uid'] as String,
        username: snap['username'] as String,
        postId: snap['postId'] as String,
        postUrl: snap['postUrl'] as String,
        profImage: snap['profImage'] as String,
        datePublished: snap['following'],
        likes: snap['likes']);
  }
}
