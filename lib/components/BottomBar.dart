import 'package:flutter/material.dart';

import '../styles/colors.dart';

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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_people_rounded),
          label: 'Friends',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_location_alt_rounded),
          label: 'Add Pinn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Me',
        ),
      ],
      currentIndex: activeIndex,
      selectedItemColor: MColors.green,
      onTap: onItemTapped,
    );
  }
}
