import 'package:flutter/material.dart';
import 'package:memz/styles/fonts.dart';
import 'package:emojis/emojis.dart';

import '../../styles/colors.dart';

class BottomBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onItemTapped;
  final int? notificationCount;

  const BottomBar({
    super.key,
    required this.activeIndex,
    required this.onItemTapped,
    this.notificationCount = 0,
  });

  BottomNavigationBarItem getNotificationItem() {
    if (notificationCount! > 0) {
      return BottomNavigationBarItem(
        icon: Stack(alignment: AlignmentDirectional.topEnd, children: [
          Text(
            Emojis.bell,
            style: SubHeading.SH26,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                height: 9,
                width: 9,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: MColors.green,
                ),
              )),
        ]),
        label: 'Notifs ($notificationCount)',
      );
    }
    return BottomNavigationBarItem(
      icon: Text(
        Emojis.bell,
        style: SubHeading.SH26,
      ),
      label: 'Notifs',
    );
  }

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
        getNotificationItem(),
        // BottomNavigationBarItem(
        //   icon: Text(
        //     Emojis.bell,
        //     style: SubHeading.SH26,
        //   ),
        //   label:
        //       notificationCount! > 0 ? 'Notifs ($notificationCount)' : 'Notifs',
        // ),
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
