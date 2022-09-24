import 'dart:typed_data';

import 'package:aladagram/resources/storage_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Sign Up User Method
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String bio,
    required BuildContext context,
    // required Uint8List file,
  }) async {
    String result = 'Some Error Occured Dude!';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        await _fireStore.collection('users').doc(cred.user!.uid).set({
          'username': userName,
          'email': email,
          'password': password,
          'bio': bio,
          'followers': [],
          'following': [],
        });
      }
    } catch (error) {
      result = error.toString();
    } finally {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
    print(result);
    return result;
  }
}
