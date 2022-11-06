import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memz/api/follow/FollowModel.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference followsDb = db.collection('follows');

String getFollowId({required String userId, required String followingId}) {
  return '$userId>$followingId';
}

class FollowStore {
  static String? userUid;

  static Future<FollowModel?> getFollowById({
    required String id,
  }) async {
    final followDoc = followsDb.doc(id);
    return followDoc
        .get()
        .then((e) => FollowModel.fromJson(e.data() as Map<String, dynamic>))
        .whenComplete(() => log('Fetched user $id'));
  }

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

  static Future<void> approveFollowRequest({
    required String followRequestId,
  }) async {
    log('approveFollowRequest $followRequestId');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final followDoc = followsDb.doc(followRequestId);

    if (currentUserId != null) {
      FollowStore.getFollowById(id: followRequestId).then((followData) {
        if (followData != null) {
          if (followData.followingId == currentUserId) {
            followDoc.update(followData.approveFollowRequest().toJson());
          } else {
            log('Does not have permission to approve follow request');
          }
        } else {
          log('No follow request to approve');
        }
      });
    }
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

  static Future<List<FollowModel>?> getUsersFollowing({
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

  static Future<List<FollowModel>?> getUsersFollowers({
    required String userId,
  }) async {
    final query = followsDb
        .where('followingId', isEqualTo: userId)
        .orderBy('followTime', descending: true);
    final Future<List<FollowModel>?> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  FollowModel.fromJson(value.data() as Map<String, dynamic>),
            ),
          ),
        );
    return result;
  }

  static Future<List<FollowModel>> getFollowRequests({
    required String userId,
  }) async {
    log('getFollowRequests $userId');
    final query = followsDb
        .where('followingId', isEqualTo: userId)
        .where('status', isEqualTo: FollowStatus.requested.index)
        .orderBy('followTime', descending: true);
    final Future<List<FollowModel>> result = query.get().then((resultsList) {
      if (resultsList.docs.isEmpty) {
        return [];
      }
      return List.from(
        resultsList.docs.map(
          (value) => FollowModel.fromJson(value.data() as Map<String, dynamic>),
        ),
      );
    });
    return result;
  }
}
