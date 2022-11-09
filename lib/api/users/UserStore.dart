import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'UserModel.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference usersDb = db.collection('users');

class UserStore {
  static String? userUid;

  static Future<void> addUser({
    required User user,
    String? username,
  }) async {
    UserModel data = UserModel(
      id: user.uid,
      username: username,
      email: user.email ?? '',
      joinDate: user.metadata.creationTime,
    );
    usersDb.doc(user.uid).set(data.toJson());
  }

  static Future<UserModel?> getUserById({
    String? id,
  }) async {
    final userDoc = usersDb.doc(id);
    return userDoc
        .get()
        .then((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
        .whenComplete(() => log('Fetched user $id'));
  }

  static Future<List<UserModel>?> searchUsersByUsername({
    required String username,
  }) async {
    final query = usersDb.where('username', isEqualTo: username);
    final Future<List<UserModel>?> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  UserModel.fromJson(value.data() as Map<String, dynamic>),
            ),
          ),
        );
    return result;
  }

  static Future<List<UserModel>> getAllUsers() async {
    log('getAllUsers');
    final query = usersDb;
    final Future<List<UserModel>> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  UserModel.fromJson(value.data() as Map<String, dynamic>),
            ),
          ),
        );
    return result;
  }

  static Future<List<UserModel>?> searchUsersByEmail({
    required String email,
  }) async {
    final query = usersDb.where('email', isEqualTo: email);
    final Future<List<UserModel>?> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  UserModel.fromJson(value.data() as Map<String, dynamic>),
            ),
          ),
        );
    return result;
  }

  static Future<bool?> isUsernameTaken({
    required String username,
  }) async {
    log('isUsernameTaken $username');
    var isTaken = false;
    final query = usersDb.where('username', isEqualTo: username);
    await query.get().then((resultsList) {
      if (resultsList.docs.isNotEmpty) {
        isTaken = true;
      }
    });

    return isTaken;
  }

  static Future<void> updateUser({
    required UserModel user,
    String? newUsername,
    String? newName,
    String? newHomebase,
    String? newEmoji,
  }) async {
    log('updateUser ${user.id}');
    usersDb.doc(user.id).update(user
        .updateEditableFields(
          newUsername: newUsername,
          newName: newName,
          newHomebase: newHomebase,
          newEmoji: newEmoji,
        )
        .toJson());
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        usersDb.doc(userUid).collection('items');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        usersDb.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => log('Note item deleted from the database'))
        .catchError((e) => log(e));
  }
}
