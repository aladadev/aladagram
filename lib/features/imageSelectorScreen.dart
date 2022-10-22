import 'package:aladagram/resources/auth_method.dart';
import 'package:flutter/material.dart';

class SelectImageScreen extends StatelessWidget {
  final Function selectImageFunc;
  const SelectImageScreen({
    Key? key,
    required this.selectImageFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              selectImageFunc(context);
            },
            icon: const Icon(Icons.upload_file),
          ),
          IconButton(
            onPressed: (() => AuthMethods().signOut(context)),
            icon: const Icon(Icons.single_bed_outlined),
          ),
        ],
      ),
    );
  }
}
