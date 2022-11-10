import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/provider/user_provider.dart';
import 'package:aladagram/resources/firestore_method.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/widgets/comment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final snapData;
  const CommentScreen({Key? key, required this.snapData}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final textController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser;
    return GestureDetector(
      onTap: (() => FocusScope.of(context).unfocus()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Comments'),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    user.photoUrl,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 8,
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Comment as ${user.username}',
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await FireStoreMethods().postComment(
                        widget.snapData['postId'],
                        textController.text,
                        user.uid,
                        user.username,
                        user.photoUrl);
                    setState(() {
                      textController.text = '';
                    });
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snapData['postId'])
              .collection('comments')
              .orderBy(
                'datePublished',
                descending: true,
              )
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  commentsnap: snapshot.data!.docs[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
