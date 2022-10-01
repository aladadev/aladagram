import 'dart:typed_data';

import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/provider/user_provider.dart';
import 'package:aladagram/resources/auth_method.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  @override
  selectImage(BuildContext context) async {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Choose a photo'),
            children: [
              SimpleDialogOption(
                child: Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    selectImage(context);
                  },
                  icon: Icon(Icons.upload_file),
                ),
                IconButton(
                  onPressed: (() => AuthMethods().signOut(context)),
                  icon: Icon(Icons.single_bed_outlined),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              title: Text(
                'Post To',
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 4,
                    ),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Write a caption',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 400,
                  height: 400,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(_file!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
