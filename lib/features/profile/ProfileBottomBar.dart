import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/styles/fonts.dart';

import '../../styles/colors.dart';

class ProfileBottomBar extends StatelessWidget {
  final String currentUserId;
  final UserModel? profileUser;

  const ProfileBottomBar({
    super.key,
    required this.currentUserId,
    this.profileUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: MColors.background,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  child: Row(
                children: [
                  Text('WYD', style: SubHeading.SH18),
                  Text(EmojiParser().get('question').code,
                      style: SubHeading.SH26),
                ],
              ))
            ],
          )),
    );
  }
}
