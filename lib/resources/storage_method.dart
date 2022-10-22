import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/material.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List? file, bool isPost) async {
    late Reference ref;

    if (!isPost) {
      ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
    }

    if (isPost) {
      String id = const Uuid().v1();
      ref = _storage
          .ref()
          .child(childName)
          .child(_auth.currentUser!.uid)
          .child(id);
    }

    if (file != null) {
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
    }
  }
}
