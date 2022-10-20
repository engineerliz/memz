import 'package:firebase_auth/firebase_auth.dart';

class MUser {
  late final String id;
  late final String username;
  late final String email;
  late final String? name;
  late final String? homeBase;
  late final DateTime? joinDate;

  MUser({
    required this.id,
    required this.username,
    required this.email,
    this.name,
    this.homeBase,
    this.joinDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'name': name,
        'homeBase': homeBase,
        'joinDate': joinDate,
      };

  factory MUser.fromJson(Map<String, dynamic> data) => MUser(
        id: data['id'],
        username: data['username'],
        email: data['email'],
        name: data['name'],
        homeBase: data['homeBase'],
        joinDate: data['joinDate'].toDate(),
      );
      
  MUser updateEditableFields({
    String? newUsername,
    String? newEmail,
    String? newName,
    String? newHomebase,
  }) =>
      MUser(
        id: id,
        joinDate: joinDate,
        username: newUsername ?? username,
        email: newEmail ?? email,
        name: newName ?? name,
        homeBase: newHomebase ?? homeBase,
      );
}
