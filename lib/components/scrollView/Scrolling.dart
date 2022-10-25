import 'package:flutter/material.dart';

class Scrolling extends StatelessWidget {
  Widget? child;

  Scrolling({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: child,
    );
  }
}
