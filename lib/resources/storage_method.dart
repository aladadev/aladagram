import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List? file,
      bool isPost, UserCredential cred) async {
    Reference ref = _storage.ref().child(childName).child(cred.user!.uid);
    if (file != null) {
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      UploadTask uploadTask = ref.putString('Null Photo');
      TaskSnapshot snapshot = await uploadTask;
      return 'No Photo';
    }
  }
}
