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
  List<Future<NotificationModel>> followRequests = [];
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    if (currentUserId != null) {
      UserStore.getUserById(id: currentUserId).then((value) {
        setState(() {
          currentUser = value;
        });
      });

      getNotifs();
    }
    super.initState();
  }

  getNotifs() {
    if (currentUserId != null) {
      NotificationStore.getFollowRequestsNotifications(userId: currentUserId!)
          .then((value) {
        setState(() {
          followRequests = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Notifications',
        
      body: PullToRefresh(
        onRefresh: () {
          getNotifs();
        },
          body: ListView(
            children: [
              ...followRequests
                    .map(
                (requestFuture) => FutureBuilder<NotificationModel>(
                  future: requestFuture,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<NotificationModel> notificationData,
                  ) {
                    if (notificationData.hasData) {
                      return NotificationTile(
                        notificationData: notificationData.data!,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
      ),
    );
  }
}
