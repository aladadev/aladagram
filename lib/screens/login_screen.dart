import 'package:aladagram/resources/auth_method.dart';
import 'package:aladagram/responsive/mobile_screen_layout.dart';
import 'package:aladagram/responsive/responsive.dart';
import 'package:aladagram/responsive/web_screen_layout.dart';
import 'package:aladagram/screens/signup_screen.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/utils.dart';
import 'package:aladagram/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailEditingController = TextEditingController();
  final _passEditingController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();

    _emailEditingController.dispose();
    _passEditingController.dispose();
  }

  signIn() async {
    setState(() {
      isLoading = true;
    });
    String result = await AuthMethods().signInUser(
        email: _emailEditingController.text,
        password: _passEditingController.text);
    setState(() {
      isLoading = false;
    });
    showSnackBar(result, context);
    if (result == 'Login Successful') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            width: double.infinity,
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                SvgPicture.asset(
                  'assets/instagram.svg',
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 32,
                ),
                TextFieldInput(
                    textEditingController: _emailEditingController,
                    hintText: 'Enter Your Email',
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  textEditingController: _passEditingController,
                  hintText: 'Enter Your Password',
                  keyboardType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: signIn,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Login'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: (() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      }),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: blueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
