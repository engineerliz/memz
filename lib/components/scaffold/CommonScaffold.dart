import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import 'CommonAppBar.dart';

class CommonScaffold extends StatefulWidget {
  final String title;
  final Widget? body;
  final int? activeTab;
  final PreferredSizeWidget? appBar;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomBar;

  const CommonScaffold({
    super.key,
    required this.title,
    this.body,
    this.activeTab,
    this.appBar,
    this.padding,
    this.bottomBar,
  });

  @override
  CommonScaffoldState createState() => CommonScaffoldState();
}

class CommonScaffoldState extends State<CommonScaffold> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.background,
      appBar: widget.appBar != null
          ? widget.appBar!
          : CommonAppBar(title: widget.title),
      body: Padding(
        padding: widget.padding != null
            ? widget.padding!
            : const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 0,
              ),
        child: widget.body,
      ),
      bottomNavigationBar: widget.bottomBar,
    );
  }
}
