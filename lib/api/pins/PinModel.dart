import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinModel {
  late final String id;
  late final String creatorId;
  late final LatLng location;
  late final DateTime creationTime;
  late final String? caption;
  late final List<String>? imgUrls;

  PinModel({
    required this.id,
    required this.creatorId,
    required this.location,
    required this.creationTime,
    this.caption,
    this.imgUrls,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'creatorId': creatorId,
        'location': {
          'latitude': location.latitude,
          'longitude': location.longitude,
        },
        'creationTime': creationTime,
        'caption': caption,
        'imgUrls': imgUrls,
      };

  factory PinModel.fromJson(Map<String, dynamic> data) => PinModel(
        id: data['id'],
        creatorId: data['creatorId'],
        location:
            LatLng(data['location']['latitude'], data['location']['longitude']),
        creationTime: data['creationTime'].toDate(),
        caption: data['caption'],
        imgUrls: data['imgUrls'],
      );

  // PinModel updateEditableFields({
  //   String? newUsername,
  //   String? newEmail,
  //   String? newName,
  //   String? newHomebase,
  // }) =>
  //     PinModel(
  //       id: id,
  //       joinDate: joinDate,
  //       username: newUsername ?? username,
  //       email: newEmail ?? email,
  //       name: newName ?? name,
  //       homeBase: newHomebase ?? homeBase,
  //     );
}
