enum FollowStatus {
  none,
  requested,
  following,
}

class FollowModel {
  late final String id;
  late final String userId;
  late final String followingId;
  late final DateTime requestTime;
  late final DateTime? followTime;
  late final FollowStatus status;

  FollowModel({
    required this.id,
    required this.userId,
    required this.followingId,
    required this.requestTime,
    this.followTime,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'followingId': followingId,
        'requestTime': requestTime,
        'followTime': followTime,
        'status': status.index,
      };

  factory FollowModel.fromJson(Map<String, dynamic> data) => FollowModel(
        id: data['id'],
        userId: data['userId'],
        followingId: data['followingId'],
        requestTime:
            data['requestTime'] != null ? data['requestTime'].toDate() : null,
        followTime:
            data['followTime'] != null ? data['followTime'].toDate() : null,
        status: FollowStatus.values[data['status']],
      );

}
