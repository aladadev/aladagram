import 'dart:typed_data';

import 'package:aladagram/resources/auth_method.dart';
import 'package:aladagram/responsive/mobile_screen_layout.dart';
import 'package:aladagram/responsive/responsive.dart';
import 'package:aladagram/responsive/web_screen_layout.dart';
import 'package:aladagram/screens/login_screen.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/utils.dart';
import 'package:aladagram/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailEditingController = TextEditingController();
  final _passEditingController = TextEditingController();
  final _bioController = TextEditingController();
  final _userNameController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();

    _emailEditingController.dispose();
    _passEditingController.dispose();
  }

  void selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    if (im != null) {
      setState(() {
        image = im;
      });
    }
  }

  signUpButton() async {
    setState(() {
      isLoading = true;
    });

    String result = await AuthMethods().signUpUser(
      email: _emailEditingController.text,
      password: _passEditingController.text,
      userName: _userNameController.text,
      bio: _bioController.text,
      context: context,
      file: image,
    );
    setState(() {
      isLoading = false;
    });

    showSnackBar(result, context);
    if (result == 'Success') {
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
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
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
                  Stack(
                    children: [
                      image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(image as Uint8List),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                            ),
                      Positioned(
                        bottom: -10,
                        right: 0,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                      textEditingController: _userNameController,
                      hintText: 'Enter Your username',
                      keyboardType: TextInputType.name),
                  const SizedBox(
                    height: 24,
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
                  TextFieldInput(
                      textEditingController: _bioController,
                      hintText: 'Enter Your Bio',
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: signUpButton,
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
                          : const Text('Sign Up'),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        }),
                        child: const Text(
                          'Sign In',
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
      ),
    );
  }
}
