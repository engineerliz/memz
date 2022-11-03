import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memz/api/follow/FollowStore.dart';

import '../../api/notifications/NotifcationModel.dart';
import '../../styles/colors.dart';
import '../../styles/fonts.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notificationData;

  NotificationTile({
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  notificationData.title,
                  style: SubHeading.SH14,
                ),
                const SizedBox(height: 4),
                Text(
                  notificationData.body,
                  style: Paragraph.P14,
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat.yMMMd().format(notificationData.timeSent)}',
                  style: Paragraph.P14.copyWith(color: MColors.grayV3),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FollowStore.approveFollowRequest(
                  followRequestId: notificationData.id);
            },
            child: Text('Approve',
                style: SubHeading.SH14.copyWith(color: MColors.black)),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: MColors.white,
            ),
          ),
        ]),
      ),
    );
  }
}
