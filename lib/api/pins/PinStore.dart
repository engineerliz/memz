import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/api/uploadFile/UploadStorage.dart';
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
    String? picUrl;

    if (imgUrls != null) {
      await UploadStorage.uploadFile(filePath: imgUrls.first).then((value) {
        print('picUrl!!! $value');
        picUrl = value;
      });
    }

    PinModel data = PinModel(
      id: pinId,
      creatorId: creatorId,
      location: location,
      caption: caption,
      imgUrls: picUrl != null ? [picUrl!] : null,
      creationTime: DateTime.now(),
    );

    print('check pinmodel ${data.toJson()}');
    pinsDb.doc(pinId).set(data.toJson());
  }

  static Future<List<PinModel>?> getPinsByUserId({
    required String userId,
  }) async {
    final query = pinsDb
        .where('creatorId', isEqualTo: userId)
        .orderBy('creationTime', descending: true);
    final Future<List<PinModel>?> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  PinModel.fromJson(value.data() as Map<String, dynamic>),
            ),
          ),
        );
    return result;
  }

  static Future<List<PinModel>> getAllPins() async {
    log('Get all pins');
    final query = pinsDb.orderBy('creationTime', descending: true);
    final Future<List<PinModel>> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) =>
                  PinModel.fromJson(value.data() as Map<String, dynamic>),
            ),
          ),
        );
    return result;
  }

  static Future<List<PinModel>> getPinsFromFollowingList(
      List<String> following) async {
    log('getPinsFromFollowingList $following');
    final pinsDb = db.collection('pins');
    final query = pinsDb
        .where('creatorId', whereIn: following)
        .orderBy('creationTime', descending: true);

    final Future<List<PinModel>> result = query.get().then(
          (resultsList) => List.from(
            resultsList.docs.map(
              (value) => PinModel.fromJson(value.data()),
            ),
          ),
        );
    return result;
  }

  static Future<void> deletePinById({
    required String pinId,
  }) async {
    log('deletePinById $pinId');
    DocumentReference documentReferencer = pinsDb.doc(pinId);
    await documentReferencer
        .delete()
        .whenComplete(() => log('Pin deleted'))
        .catchError((e) => log(e));
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
      'title': title,
      'description': description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => log('Note item updated in the database'))
        .catchError((e) => log(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        pinsDb.doc(userUid).collection('items');

    return notesItemCollection.snapshots();
  }
}
