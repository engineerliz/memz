enum NotificationType {
  simple,
  followRequest,
  smylRequest,
}

class NotificationModel {
  late final String id;
  late final String userId;
  late final DateTime timeSent;
  late final String title;
  late final String body;
  late final NotificationType type;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.timeSent,
    required this.title,
    required this.body,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'timeSent': timeSent,
        'title': title,
        'body': body,
        'type': type.index,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> data) =>
      NotificationModel(
        id: data['id'],
        userId: data['userId'],
        timeSent: data['timeSent'] != null ? data['timeSent'].toDate() : null,
        title: data['title'],
        body: data['body'],
        type: NotificationType.values[data['type']],
      );
}
