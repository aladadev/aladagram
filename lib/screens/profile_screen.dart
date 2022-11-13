// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aladagram/resources/firestore_method.dart';
import 'package:aladagram/utility/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/widgets/follow_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  var postLengthCount = 0;
  var followersLength = 0;
  var followingLength = 0;
  var isFollowing = false;

  var userData = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      followersLength = userData['followers'].length;
      followingLength = userData['following'].length;
      postLengthCount = postSnap.docs.length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    buildProfColumn(postLengthCount, 'post'),
                                    buildProfColumn(
                                        followersLength, 'followers'),
                                    buildProfColumn(
                                        followingLength, 'following'),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Edit Profile',
                                            textColor: primaryColor)
                                        : isFollowing
                                            ? FollowButton(
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followersLength--;
                                                  });
                                                },
                                                backgroundColor:
                                                    Colors.redAccent,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: primaryColor)
                                            : FollowButton(
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    followersLength++;
                                                  });
                                                },
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                borderColor: Colors.grey,
                                                text: 'Follow',
                                                textColor: primaryColor)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return AlignedGridView.count(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return Image.network(
                            snapshot.data!.docs[index]['postUrl']);
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildProfColumn(
    int num,
    String label,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
