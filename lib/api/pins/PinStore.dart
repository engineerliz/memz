import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import 'PinModel.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference pinsDb = db.collection('pins');

class PinStore {
  static String? userUid;

  static Future<void> addPin({
    required String creatorId,
    required LatLng location,
    String? caption,
    List<String>? imgUrls,
  }) async {
    var uuid = const Uuid();
    final String pinId = uuid.v4();
    PinModel data = PinModel(
      id: pinId,
      creatorId: creatorId,
      location: location,
      caption: caption,
      imgUrls: imgUrls,
      creationTime: DateTime.now(),
    );
    pinsDb.doc(pinId).set(data.toJson());
  }

  // static Future<List<PinModel>?> getPinsByUserId({
  static Future<List<PinModel>?> getPinsByUserId({
    required String userId,
  }) async {
    print('getPinsByUserId $userId');
    final query = pinsDb
        .where('creatorId', isEqualTo: userId)
        .orderBy('creationTime', descending: true);
    final Future<List<PinModel>?> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  PinModel.fromJson(value.data() as Map<String, dynamic>),
            ),
            // value.docs.map((value) => print(
            //         'value.data ${PinModel.fromJson(value.data() as Map<String, dynamic>)}')
            //     ),
          ),
        );
    print('result ${result}');
    result.then((test) => print('test? ${test?.first.toJson()}'));
    return result;
    // .then((value) => print('docs first ${value.docs.first.data()}'));

    // .then((value) => value.docs.map((e) => print('dataa ${e.data()}')));
    // return userDoc
    //     .get()
    //     .then((e) => PinModel.fromJson(e.data() as Map<String, dynamic>));
    // return userDoc.get().then((value) => PinModel.fromJson(json.encode(value.data())));
  }

  static Future<void> updateUser({
    required PinModel user,
  }) async {
    pinsDb.doc(user.id).set(user.toJson());
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        pinsDb.doc(userUid).collection('items').doc(docId);

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
        pinsDb.doc(userUid).collection('items');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        pinsDb.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => log('Note item deleted from the database'))
        .catchError((e) => log(e));
  }
}
