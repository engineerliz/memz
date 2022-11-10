import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';

import '../../features/profile/UserProfileView.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  const UserTile({
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfileView(
                  userId: user.id,
                ),
              ),
            );
          },
      child: Container(
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
                user.emoji ?? EmojiParser().get('wave').code,
                style: SubHeading.SH22,
              ),
              const SizedBox(width: 8),
              Text(
                user.username ?? '',
                style: SubHeading.SH14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
