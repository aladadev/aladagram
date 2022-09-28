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
}
