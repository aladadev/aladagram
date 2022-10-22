import 'dart:typed_data';

import 'package:aladagram/features/imageSelectorScreen.dart';
import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/provider/user_provider.dart';
import 'package:aladagram/resources/auth_method.dart';
import 'package:aladagram/resources/firestore_method.dart';
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
  TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;

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
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void postImage(
    String uid,
    String username,
    String profileImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String result = await FireStoreMethods().uploadPost(
          descriptionController.text, _file!, uid, username, profileImage);
      if (result == 'Success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted', context);
      } else {
        setState(() {
          _isLoading = true;
        });
        showSnackBar(result, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _file = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? SelectImageScreen(
            selectImageFunc: selectImage,
          )
        : GestureDetector(
            onTap: (() => FocusScope.of(context).unfocus()),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return SelectImageScreen(selectImageFunc: selectImage);
                      },
                    ));
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                title: Text(
                  'Post To',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      postImage(
                        user.uid,
                        user.username,
                        user.photoUrl,
                      );
                    },
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
                  _isLoading
                      ? LinearProgressIndicator()
                      : const SizedBox(
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
                          controller: descriptionController,
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
            ),
          );
  }
}
