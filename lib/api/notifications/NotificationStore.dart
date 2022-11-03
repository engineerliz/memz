import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memz/api/follow/FollowStore.dart';
import 'package:memz/api/notifications/NotifcationModel.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference followsDb = db.collection('notifications');

class NotificationStore {
  static Future<List<Future<NotificationModel>>>
      getFollowRequestsNotifications({
    required String userId,
  }) {
    log('getFollowRequestsNotifications $userId');
    return FollowStore.getFollowRequests(userId: userId).then((value) {
      return value.map((request) async {
        UserModel? user;
        await UserStore.getUserById(id: request.userId).then(((value) {
          user = value;
        }));

        return NotificationModel(
          id: request.id,
          userId: request.userId,
          timeSent: request.requestTime,
          title: user?.username != null
              ? '${user!.username} requested to follow you'
              : 'Someone requested to follow you',
          body: 'Accept the follow request to let them see your pins.',
          type: NotificationType.followRequest,
        );
      }).toList();
    });
  }
}
