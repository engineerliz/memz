import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:memz/features/profile/UserProfileView.dart';

import '../../api/notifications/NotificationStore.dart';
import '../../api/users/UserModel.dart';
import '../../api/users/UserStore.dart';
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
  UserModel? userData;
  late int _selectedIndex;
  User? user = FirebaseAuth.instance.currentUser;
  late LocationPermission? locationPermission =
      LocationPermission.unableToDetermine;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings? notifPermission;
  String? messagingToken;
  int notificationCount = 0;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print('handleMessage1 ${message}');
    print('handleMessage2 ${message.data}');
    print('handleMessage3 ${message.toString()}');

    setState(() {
      _selectedIndex = 2;
    });
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(
    //     context,
    //     '/chat',
    //     arguments: ChatArguments(message),
    //   );
    // }
  }

  void storeUserToken() {
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        messagingToken = token;
      });
      if (user?.uid != null && token != null) {
        UserStore.updateUserToken(
            userId: user!.uid, token: token, time: DateTime.now());
      }
    });
    print('user token $messagingToken');
  }

  @override
  initState() {
    super.initState();
    UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid ?? '')
        .then(
      (value) => setState(() {
        userData = value;
      }),
    );
    _selectedIndex = widget.activeTab ?? 0;
    Future.delayed(Duration.zero, () async {
      var permission = await Geolocator.checkPermission();
      NotificationSettings newNotifPermission =
          await messaging.getNotificationSettings();

      setState(() {
        locationPermission = permission;
        notifPermission = newNotifPermission;
      });
    });

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      NotificationStore.getFollowRequestsNotifications(
              userId: FirebaseAuth.instance.currentUser!.uid)
          .then((value) {
        setState(() {
          notificationCount = value.length;
        });
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    setupInteractedMessage();
    storeUserToken();
  }

  void askForLocation() {
    Future.delayed(Duration(seconds: 2), () async {
      var newPermission = await Geolocator.requestPermission();

      setState(() {
        locationPermission = newPermission;
      });
    });
  }

  void askForNotificationPermission() async {
    log('askForNotificationPermission');
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('user token?? $messagingToken');

    // if (locationPermission == LocationPermission.unableToDetermine) {
    //   askForLocation();
    // }
    if (notifPermission == null) {
      askForNotificationPermission();
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
        notificationCount: notificationCount,
      ),
    );
  }
}
