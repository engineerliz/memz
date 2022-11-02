import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memz/api/follow/FollowModel.dart';
import 'package:memz/api/follow/FollowStore.dart';
import 'package:memz/api/notifications/NotifcationModel.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference followsDb = db.collection('notifications');

String getFollowId({required String userId, required String followingId}) {
  return '$userId>$followingId';
}

class NotificationStore {
  static String? userUid;

  static Future<void> requestFollowUser({
    required String userId,
    required String followingId,
  }) async {
    log('requestFollowUser: from $userId to $followingId');
    bool isFollowingOrRequested = false;

    await getFollowStatus(userId: userId, followingId: followingId).then(
      (value) {
        print('getFollowStatus $value');
        isFollowingOrRequested = value != FollowStatus.none;
      },
    );
    if (!isFollowingOrRequested) {
      String id = getFollowId(userId: userId, followingId: followingId);
      FollowModel data = FollowModel(
        id: id,
        userId: userId,
        followingId: followingId,
        requestTime: DateTime.now(),
        status: FollowStatus.requested,
      );
      followsDb
          .doc(id)
          .set(data.toJson())
          .whenComplete(() => log('User follow requested'))
          .catchError((e) => log(e));
      ;
    }
  }

  static Future<void> unfollowUser({
    required String userId,
    required String followingId,
  }) async {
    String id = getFollowId(userId: userId, followingId: followingId);

    await followsDb
        .doc(id)
        .delete()
        .whenComplete(() => log('User unfollowed'))
        .catchError((e) => log(e));
  }

  static Future<FollowStatus> getFollowStatus({
    required String userId,
    required String followingId,
  }) async {
    final followDoc =
        followsDb.doc(getFollowId(userId: userId, followingId: followingId));
    return followDoc.get().then((value) {
      if (value.data() != null) {
        return FollowModel.fromJson(value.data() as Map<String, dynamic>)
            .status;
      }
      return FollowStatus.none;
    });
  }

  static Future<bool?> isFollowing({
    required String userId,
    required String followingId,
  }) async {
    final followDoc =
        followsDb.doc(getFollowId(userId: userId, followingId: followingId));
    return followDoc.get().then((value) {
      if (value.data() != null) {
        return FollowModel.fromJson(value.data() as Map<String, dynamic>)
                .status ==
            FollowStatus.following;
      }
      return false;
    });
  }

  static Future<bool?> isFollowRequested({
    required String userId,
    required String followingId,
  }) async {
    final followDoc =
        followsDb.doc(getFollowId(userId: userId, followingId: followingId));
    return followDoc.get().then((value) {
      if (value.data() != null) {
        return FollowModel.fromJson(value.data() as Map<String, dynamic>)
                .status ==
            FollowStatus.requested;
      }
      return false;
    });
  }

  static Future<List<FollowModel>?> getFollowingUsers({
    required String userId,
  }) async {
    final query = followsDb
        .where('userId', isEqualTo: userId)
        .orderBy('followTime', descending: true);
    final Future<List<FollowModel>?> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) {
                return FollowModel.fromJson(
                    value.data() as Map<String, dynamic>);
              },
            ),
          ),
        );
    return result;
  }

  static Future<List<NotificationModel>> getFollowRequestsNotifications({
    required String userId,
  }) async {
    log('getFollowRequestsNotifications $userId');
    List<FollowModel> followRequests = [];
    await FollowStore.getFollowRequests(userId: userId).then((value) {
      followRequests = value;
    });
    return followRequests.map((request) {
      return NotificationModel(
        id: request.id,
        userId: request.userId,
        timeSent: request.requestTime,
        title: 'Follow request',
        body: 'Accept the follow request to let them see your pins.',
        type: NotificationType.followRequest,
      );
    }).toList();
  }

  // static Future<List<UserModel>?> searchUsersByUsername({
  //   required String username,
  // }) async {
  //   final query = followsDb.where('username', isEqualTo: username);
  //   final Future<List<UserModel>?> result = query.get().then(
  //         (resultsList) => List.from(
  //           resultsList.docs.map(
  //             (value) =>
  //                 UserModel.fromJson(value.data() as Map<String, dynamic>),
  //           ),
  //         ),
  //       );
  //   return result;
  // }

  // static Future<List<UserModel>?> searchUsersByEmail({
  //   required String email,
  // }) async {
  //   final query = followsDb.where('email', isEqualTo: email);
  //   final Future<List<UserModel>?> result = query.get().then(
  //         (resultsList) => List.from(
  //           resultsList.docs.map(
  //             (value) =>
  //                 UserModel.fromJson(value.data() as Map<String, dynamic>),
  //           ),
  //         ),
  //       );
  //   return result;
  // }

  // static Future<void> updateUser({
  //   required UserModel user,
  // }) async {
  //   followsDb.doc(user.id).set(user.toJson());
  // }

  // static Future<void> updateItem({
  //   required String title,
  //   required String description,
  //   required String docId,
  // }) async {
  //   DocumentReference documentReferencer =
  //       followsDb.doc(userUid).collection('items').doc(docId);

  //   Map<String, dynamic> data = <String, dynamic>{
  //     "title": title,
  //     "description": description,
  //   };

  //   await documentReferencer
  //       .update(data)
  //       .whenComplete(() => log("Note item updated in the database"))
  //       .catchError((e) => log(e));
  // }

  // static Stream<QuerySnapshot> readItems() {
  //   CollectionReference notesItemCollection =
  //       followsDb.doc(userUid).collection('items');

  //   return notesItemCollection.snapshots();
  // }

}
