import 'package:flutter/material.dart';
import 'package:memz/features/profile/ProfileView.dart';
import 'package:memz/styles/fonts.dart';

import '../styles/colors.dart';
import 'BottomBar.dart';

class CommonScaffold extends StatefulWidget {
  final String? title;
  final Widget? body;
  final int? activeTab;

  const CommonScaffold({
    super.key,
    this.title,
    this.body,
    this.activeTab,
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
            builder: (context) => ProfileView(),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: MColors.background,
      appBar: widget.title != null
          ? AppBar(
              elevation: 0,
              backgroundColor: MColors.background,
              titleSpacing: 0,
              title: Row(children: [Text(widget.title!, style: Heading.H26)]),
            )
          : null,
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
        padding: const EdgeInsets.only(
              left: 0,
              right: 0,
              top: 15,
          bottom: 20.0,
        ),
        child: widget.body,
          )),
      // bottomNavigationBar: BottomBar(
      //   activeIndex: widget.activeTab ?? _selectedIndex,
      //   onItemTapped: onItemTapped,
      // ),
    );
  }
}
