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
  }) async {
    UserModel data = UserModel(
      id: user.uid,
      username: user.displayName ?? '',
      email: user.email ?? '',
      joinDate: user.metadata.creationTime,
    );
    usersDb.doc(user.uid).set(data.toJson());
  }

  static Future<UserModel?> getUserById({
    required String id,
  }) async {
    final userDoc = usersDb.doc(id);
    return userDoc
        .get()
        .then((e) => UserModel.fromJson(e.data() as Map<String, dynamic>));
    // return userDoc.get().then((value) => UserModel.fromJson(json.encode(value.data())));
  }

  static Future<void> updateUser({
    required UserModel user,
  }) async {
    usersDb.doc(user.id).set(user.toJson());
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        usersDb.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => log("Note item updated in the database"))
        .catchError((e) => log(e));
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
