import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

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
      height: 60,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MColors.grayV9,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              EmojiParser().get('wave').code,
              style: SubHeading.SH22,
            ),
            const SizedBox(width: 8),
            Text(
              notificationData.title,
              style: SubHeading.SH14,
            )
          ],
        ),
      ),
    );
  }
}
