import 'package:aladagram/screens/add_post_screen.dart';
import 'package:aladagram/screens/newsfeed_screen.dart';
import 'package:aladagram/screens/profile_screen.dart';
import 'package:aladagram/screens/search_screen.dart';
import 'package:aladagram/widgets/newsfeed_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const kWebScreenSize = 600;

List<Widget> homeScreenItems = [
  NewsFeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
