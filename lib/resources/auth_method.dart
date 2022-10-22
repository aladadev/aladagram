import 'dart:typed_data';

import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/resources/storage_method.dart';
import 'package:aladagram/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _fireStore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnapshot(snap);
  }

  //Sign Up User Method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required BuildContext context,
    required Uint8List? file,
  }) async {
    String result = 'Please Enter The Form!';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethod().uploadImageToStorage(
          'profilePic',
          file,
          false,
        );
        UserModel userModel = UserModel(
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            username: userName,
            uid: cred.user!.uid,
            followers: [],
            following: [],
            password: password);
        await _fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userModel.toJson());

        result = 'Success';
      }
    } catch (error) {
      result = error.toString();
    }

    return result;
  }

  Future<String> signInUser(
      {required String email, required String password}) async {
    String result = 'Please Enter The Form!';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = 'Login Successful';
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<void> signOut(BuildContext context) async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (((context) => LoginScreen()))));
    await _auth.signOut();
  }
}
