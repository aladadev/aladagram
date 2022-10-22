import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final String password;
  const UserModel(
      {required this.email,
      required this.bio,
      required this.photoUrl,
      required this.username,
      required this.uid,
      required this.followers,
      required this.following,
      required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
      'followers': [],
      'following': [],
      'photoUrl': photoUrl,
      'uid': uid,
    };
  }

  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
        email: snap['email'] as String,
        bio: snap['bio'] as String,
        photoUrl: snap['photoUrl'] as String,
        username: snap['username'] as String,
        uid: snap['uid'] as String,
        followers: snap['followers'] as List,
        following: snap['following'] as List,
        password: snap['password'] as String);
  }
}
