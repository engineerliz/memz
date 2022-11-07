import 'package:flutter/material.dart';
import 'package:memz/styles/fonts.dart';
import 'package:emojis/emojis.dart';

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
      type: BottomNavigationBarType.fixed,
      unselectedLabelStyle: SubHeading.SH12,
      selectedLabelStyle: SubHeading.SH12.copyWith(color: MColors.green),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Text(
            Emojis.peopleHoldingHands,
            style: SubHeading.SH26,
          ),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Text(
            Emojis.roundPushpin,
            style: SubHeading.SH26,
          ),
          label: 'Drop a Pin',
        ),
        BottomNavigationBarItem(
          icon: Text(
            Emojis.bell,
            style: SubHeading.SH26,
          ),
          label: 'Notifs',
        ),
        BottomNavigationBarItem(
          icon: Text(
            Emojis.wavingHand,
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
