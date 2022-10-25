import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:memz/styles/fonts.dart';

import '../../styles/colors.dart';

class BottomBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onItemTapped;

  const BottomBar({
    super.key,
    required this.activeIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedLabelStyle: SubHeading.SH12,
      selectedLabelStyle: SubHeading.SH12.copyWith(color: MColors.green),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Text(
            EmojiParser().get('people_holding_hands').code,
            style: SubHeading.SH26,
          ),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Text(
            EmojiParser().get('round_pushpin').code,
            style: SubHeading.SH26,
          ),
          label: 'Add Pin',
        ),
        BottomNavigationBarItem(
          icon: Text(
            EmojiParser().get('wave').code,
            style: SubHeading.SH26,
          ),
          label: 'Me',
        ),
      ],
      currentIndex: activeIndex,
      selectedItemColor: MColors.green,
      unselectedItemColor: MColors.grayV5,
      backgroundColor: MColors.background,
      onTap: onItemTapped,
    );
  }
}
