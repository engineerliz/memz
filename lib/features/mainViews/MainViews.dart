import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/features/profile/ProfileView.dart';

import '../../components/BottomBar.dart';
import '../../screens/authentication/email_password/user_info_screen.dart';
import '../../styles/colors.dart';
import '../addPin/AddPin.dart';

class MainViews extends StatefulWidget {
  final String? title;
  final Widget? body;
  final int? activeTab;

  const MainViews({
    super.key,
    this.title,
    this.body,
    this.activeTab,
  });

  @override
  MainViewsState createState() => MainViewsState();
}

class MainViewsState extends State<MainViews> {
  late int _selectedIndex;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.background,
      appBar: widget.title != null
          ? AppBar(
              elevation: 0,
              backgroundColor: MColors.background,
              title: Text(widget.title!),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
        ),
        child: (() {
          if (_selectedIndex == 0) {
            return UserInfoScreen(
              user: user,
            );
          }
          if (_selectedIndex == 1) {
            return AddPin();
          }
          if (_selectedIndex == 2) {
            return const ProfileView();
          }
        }()),
      ),
      bottomNavigationBar: BottomBar(
        activeIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
