import 'package:flutter/material.dart';
import 'package:memz/components/CommonScaffold.dart';

import '../../components/map/Map.dart';

class AddPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Add Pin',
      body: Container(
        height: 300,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: MapSample(),
      ),
    );
  }
}
