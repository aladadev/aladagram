import 'package:aladagram/resources/auth_method.dart';
import 'package:aladagram/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () async {
              await AuthMethods().signOut(context);
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: ((context) => LoginScreen())));
            },
            child: Text('This is mobile Layout with signout')),
      ),
    );
  }
}
