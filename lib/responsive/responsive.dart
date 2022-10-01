import 'package:aladagram/provider/user_provider.dart';
import 'package:aladagram/utility/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
        : LayoutBuilder(
            builder: ((context, constraints) {
              if (constraints.maxWidth > kWebScreenSize) {
                return widget.webScreenLayout;
              }
              return widget.mobileScreenLayout;
            }),
          );
  }
}
