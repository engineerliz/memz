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

  static Future<void> followUser({
    required String userId,
    required String followingId,
  }) async {
    String id = getFollowId(userId: userId, followingId: followingId);
    FollowModel data = FollowModel(
      id: id,
      userId: userId,
      followingId: followingId,
      followTime: DateTime.now(),
    );
    followsDb.doc(id).set(data.toJson());
  }

  static Future<bool?> isFollowing({
    required String userId,
    required String followingId,
  }) async {
    final followDoc =
        followsDb.doc(getFollowId(userId: userId, followingId: followingId));
    return followDoc.get().then((value) => value.data() != null);
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

  // static Future<void> deleteItem({
  //   required String docId,
  // }) async {
  //   DocumentReference documentReferencer =
  //       followsDb.doc(userUid).collection('items').doc(docId);

  //   await documentReferencer
  //       .delete()
  //       .whenComplete(() => log('Note item deleted from the database'))
  //       .catchError((e) => log(e));
  // }
}
