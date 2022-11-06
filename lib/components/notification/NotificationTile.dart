import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memz/api/follow/FollowStore.dart';

import '../../api/notifications/NotifcationModel.dart';
import '../../features/profile/UserProfileView.dart';
import '../../styles/colors.dart';
import '../../styles/fonts.dart';

class NotificationTile extends StatefulWidget {
  final FollowRequestNotificationModel notificationData;

  NotificationTile({
    required this.notificationData,
  });
  @override
  NotificationTileState createState() => NotificationTileState();
}

class NotificationTileState extends State<NotificationTile> {
  bool isApproved = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(children: [
          Flexible(
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserProfileView(
                        userId: widget.notificationData.requesterId,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.notificationData.title,
                      style: SubHeading.SH14,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.notificationData.body,
                      style: Paragraph.P14,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.yMMMd().format(widget.notificationData.timeSent)}',
                      style: Paragraph.P14.copyWith(color: MColors.grayV3),
                    ),
                  ],
                )),
          ),
          ElevatedButton(
            onPressed: () {
              FollowStore.approveFollowRequest(
                      followRequestId: widget.notificationData.id)
                  .whenComplete(() => setState(() {
                        isApproved = true;
                      }));
            },
            child: Text(isApproved ? 'Approved' : 'Approve',
                style: SubHeading.SH14.copyWith(
                    color: isApproved ? MColors.grayV3 : MColors.black)),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: isApproved ? MColors.grayV7 : MColors.white,
            ),
          ),
        ]),
      ),
    );
  }
}
