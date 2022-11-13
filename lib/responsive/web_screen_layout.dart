import 'package:aladagram/utility/colors.dart';
import 'package:aladagram/utility/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            color: _page == 0 ? primaryColor : secondaryColor,
            onPressed: () {
              navigationTapped(0);
            },
            icon: const Icon(
              Icons.home,
            ),
          ),
          IconButton(
            color: _page == 1 ? primaryColor : secondaryColor,
            onPressed: () {
              navigationTapped(1);
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            color: _page == 2 ? primaryColor : secondaryColor,
            onPressed: () {
              navigationTapped(2);
            },
            icon: const Icon(
              Icons.add_a_photo_outlined,
            ),
          ),
          IconButton(
            color: _page == 3 ? primaryColor : secondaryColor,
            onPressed: () {
              navigationTapped(3);
            },
            icon: const Icon(
              Icons.supervised_user_circle_rounded,
            ),
          ),
        ],
      ),
      body: PageView(
        children: homeScreenItems,
        controller: _pageController,
        onPageChanged: navigationTapped,
      ),
    );
  }
}
