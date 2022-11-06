import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memz/features/profile/UserProfileView.dart';

import '../../components/scaffold/BottomBar.dart';
import '../../styles/colors.dart';
import '../addPin/AddPinView.dart';
import '../friendsFeed/FriendsFeedView.dart';
import '../notifications/NotificationView.dart';
import '../profile/MyProfileView.dart';

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
  late LocationPermission? locationPermission =
      LocationPermission.unableToDetermine;

  @override
  initState() {
    _selectedIndex = widget.activeTab ?? 0;
    Future.delayed(Duration.zero, () async {
      var permission = await Geolocator.checkPermission();
      setState(() {
        locationPermission = permission;
      });
    });
    super.initState();
  }

  void askForLocation() {
    Future.delayed(Duration(seconds: 2), () async {
      var newPermission = await Geolocator.requestPermission();

      setState(() {
        locationPermission = newPermission;
      });
    });
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (locationPermission == LocationPermission.unableToDetermine) {
      askForLocation();
    }

    return Scaffold(
      backgroundColor: MColors.background,
      appBar: widget.title != null
          ? AppBar(
              elevation: 0,
              backgroundColor: MColors.background,
              title: Text(widget.title!),
            )
          : null,
      body: IndexedStack(
        children: <Widget>[
          FriendsFeedView(),
          AddPinView(),
          NotificationView(),
          MyProfileView(),
        ],
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomBar(
        activeIndex: _selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
