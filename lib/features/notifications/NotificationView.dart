import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/notifications/NotifcationModel.dart';
import 'package:memz/api/notifications/NotificationStore.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/scaffold/PullToRefresh.dart';

import '../../api/users/UserModel.dart';
import '../../components/notification/NotificationTile.dart';

class NotificationView extends StatefulWidget {
  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  UserModel? currentUser;
  List<NotificationModel> followRequests = [];
  @override
  void initState() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    print('notifications $currentUserId');
    if (currentUserId != null) {
      UserStore.getUserById(id: currentUserId).then((value) {
        setState(() {
          currentUser = value;
        });
      });

      NotificationStore.getFollowRequestsNotifications(userId: currentUserId)
          .then((value) {
        followRequests = value;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Notifications',
      body: PullToRefresh(
        onRefresh: () {},
        body: ListView(
          children: [
            ...followRequests
                .map((request) => NotificationTile(notificationData: request))
          ],
        ),
      ),
    );
  }
}
