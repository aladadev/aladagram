import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/global.dart';
import 'package:aladagram/widgets/newsfeed_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: devicewidth > kWebScreenSize
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                toolbarHeight: 60,
                backgroundColor: devicewidth > kWebScreenSize
                    ? webBackgroundColor
                    : mobileBackgroundColor,
                title: SvgPicture.asset(
                  'assets/instagram.svg',
                  color: primaryColor,
                  height: 32,
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.messenger_outline_rounded,
                    ),
                  ),
                ],
              ),
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        devicewidth > kWebScreenSize ? devicewidth * 0.3 : 0,
                    vertical: devicewidth > kWebScreenSize ? 15 : 0,
                  ),
                  child: NewsFeed(
                    snapshotdata: snapshot.data!.docs[index],
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              'No post has been made yet!',
            ),
          );
        },
      ),
    );
  }
}
