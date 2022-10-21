import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memz/features/profile/ProfileView.dart';

import '../../components/BottomBar.dart';
import '../../screens/authentication/email_password/user_info_screen.dart';
import '../../styles/colors.dart';
import '../addPin/AddPinView.dart';

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
    _selectedIndex = 0;
    Future.delayed(Duration.zero, () async {
      var permission = await Geolocator.checkPermission();
      setState(() {
        locationPermission = permission;
      });
    });
    super.initState();
  }

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   var permission = await Geolocator.checkPermission();
  //   super.setState(() {
  //     locationPermission = permission;
  //   }); // to update widget data
  //   /// new
  //   print('locationPermission $locationPermission');
  // }

  void askForLocation() {
    Future.delayed(Duration(seconds: 2), () async {
      LocationPermission permission = await Geolocator.requestPermission();
      var newPermission = await Geolocator.checkPermission();
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
    print('locationPermission? $locationPermission');
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
            return AddPinView();
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
