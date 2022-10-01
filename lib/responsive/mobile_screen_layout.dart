import 'package:aladagram/models/usermodel.dart';
import 'package:aladagram/provider/user_provider.dart';
import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/global.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);

    setState(() {
      _page = page;
    });
  }

  // void onChangedPage(int page) {
  //   setState(() {
  //     _page = page;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: homeScreenItems,
        // onPageChanged: onChangedPage,
      ),
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          onTap: navigationTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            )),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
            ),
          ]),
    );
  }
}
