class FollowModel {
  late final String id;
  late final String userId;
  late final String followingId;
  late final DateTime followTime;

  FollowModel({
    required this.id,
    required this.userId,
    required this.followingId,
    required this.followTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'followingId': followingId,
        'followTime': followTime,
      };

  factory FollowModel.fromJson(Map<String, dynamic> data) => FollowModel(
        id: data['id'],
        userId: data['userId'],
        followingId: data['followingId'],
        followTime: data['followTime'].toDate(),
      );

  // FollowModel updateEditableFields({
  //   String? newUsername,
  //   String? newEmail,
  //   String? newName,
  //   String? newHomebase,
  // }) =>
  //     FollowModel(
  //       id: id,
  //       joinDate: joinDate,
  //       username: newUsername ?? username,
  //       email: newEmail ?? email,
  //       name: newName ?? name,
  //       homeBase: newHomebase ?? homeBase,
  //     );
}
