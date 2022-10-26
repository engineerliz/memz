import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';

import '../../api/follow/FollowModel.dart';
import '../../styles/fonts.dart';

class ProfileAboutTab extends StatelessWidget {
  final String? username;
  final String? homebase;
  final int? friendsCount;
  final DateTime? joinDate;
  final int? pinCount;
  final List<FollowModel>? followersList;
  final List<FollowModel>? followingList;

  const ProfileAboutTab({
    this.username,
    this.homebase,
    this.friendsCount,
    this.joinDate,
    this.pinCount,
    this.followersList,
    this.followingList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text('🏠', style: TextStyle(fontSize: 22)),
            const SizedBox(
              width: 6,
            ),
            Text(
              homebase ?? '',
              style: SubHeading.SH14,
            )
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('🎁', style: TextStyle(fontSize: 22)),
            const SizedBox(
              width: 6,
            ),
            if (joinDate != null)
              Text('Joined ${DateFormat.yMMMd().format(joinDate!)}',
                  style: SubHeading.SH14)
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 22)),
            const SizedBox(
              width: 6,
            ),
            if (joinDate != null)
              Text('${followersList?.length ?? 0} followers',
                  style: SubHeading.SH14)
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Text('👀', style: TextStyle(fontSize: 22)),
            const SizedBox(
              width: 6,
            ),
            if (joinDate != null)
              Text('${followingList?.length ?? 0} following',
                  style: SubHeading.SH14)
          ],
        ),

      ],
    );
  }
}
