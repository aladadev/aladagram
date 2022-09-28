import 'package:aladagram/responsive/mobile_screen_layout.dart';
import 'package:aladagram/responsive/responsive.dart';
import 'package:aladagram/responsive/web_screen_layout.dart';
import 'package:aladagram/screens/login_screen.dart';
import 'package:aladagram/screens/signup_screen.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDqZ0kR7fdWFlMt4s7MJR450G8-2dXTEkM",
        appId: "1:922393771514:web:97a0717752b07668653843",
        messagingSenderId: "922393771514",
        projectId: "alagram-80283",
        storageBucket: "alagram-80283.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlaGram',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      // home: SignUpScreen(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          return const LoginScreen();
        }),
      ),
    );
  }
}
