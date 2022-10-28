import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/styles/fonts.dart';

import '../../styles/colors.dart';

class SingleButtonBottomBar extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final String? currentUserId;
  final UserModel? profileUser;

  const SingleButtonBottomBar({
    super.key,
    this.child,
    this.onTap,
    this.currentUserId,
    this.profileUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: MColors.background,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [if (child != null) child!],
              ))),
    );
  }
}
