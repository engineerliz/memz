import 'package:flutter/material.dart';
import 'package:memz/features/profile/MyProfileView.dart';
import 'package:memz/styles/fonts.dart';

import '../../styles/colors.dart';
import 'BottomBar.dart';
import 'CommonAppBar.dart';

class CommonScaffold extends StatefulWidget {
  final String title;
  final Widget? body;
  final int? activeTab;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry? padding;

  const CommonScaffold({
    super.key,
    required this.title,
    this.body,
    this.activeTab,
    this.appBar,
    this.padding,
  });

  @override
  CommonScaffoldState createState() => CommonScaffoldState();
}

class CommonScaffoldState extends State<CommonScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      if (index == 2) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyProfileView(),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: MColors.background,
      appBar: widget.appBar != null
          ? widget.appBar!
          : CommonAppBar(title: widget.title),
      body: Padding(
        padding: widget.padding != null
            ? widget.padding!
            : const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
                bottom: 20.0,
              ),
        child: widget.body,
      ),
      // bottomNavigationBar: BottomBar(
      //   activeIndex: widget.activeTab ?? _selectedIndex,
      //   onItemTapped: onItemTapped,
      // ),
    );
  }
}
