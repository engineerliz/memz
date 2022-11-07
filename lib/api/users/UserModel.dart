import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  late final String id;
  late final String? username;
  late final String email;
  late final String? name;
  late final String? homeBase;
  late final DateTime? joinDate;
  late final String? emoji;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    this.name,
    this.homeBase,
    this.joinDate,
    this.emoji,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'name': name,
        'homeBase': homeBase,
        'joinDate': joinDate,
        'emoji': emoji,
      };

  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
        id: data['id'],
        username: data['username'],
        email: data['email'],
        name: data['name'],
        homeBase: data['homeBase'],
        joinDate: data['joinDate'].toDate(),
        emoji: data['emoji'],
      );

  UserModel updateEditableFields({
    String? newUsername,
    String? newEmail,
    String? newName,
    String? newHomebase,
    String? newEmoji,
  }) =>
      UserModel(
        id: id,
        joinDate: joinDate,
        username: newUsername ?? username,
        email: newEmail ?? email,
        name: newName ?? name,
        homeBase: newHomebase ?? homeBase,
        emoji: newEmoji ?? emoji,
      );
}
