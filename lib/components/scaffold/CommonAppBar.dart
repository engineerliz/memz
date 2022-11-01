import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/fonts.dart';

class CommonAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final Widget? rightWidget;

  CommonAppBar({
    super.key,
    required this.title,
    this.rightWidget,
  })
      : preferredSize = const Size.fromHeight(50.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: MColors.background,
      titleSpacing: 12,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Heading.H26),
          if (rightWidget != null) rightWidget!
        ],
      ),
    );
  }
}
