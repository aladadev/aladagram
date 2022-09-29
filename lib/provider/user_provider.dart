import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/resources/auth_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUser => _userModel!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _userModel = user;

    notifyListeners();
  }
}
