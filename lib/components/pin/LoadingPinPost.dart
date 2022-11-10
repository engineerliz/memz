import 'package:flutter/material.dart';

import '../shimmer/ShimmerBox.dart';

class LoadingPinPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          ShimmerBox(
            height: 35,
            width: 35,
            radius: 35,
          ),
          const SizedBox(width: 6),
          ShimmerBox(
            height: 25,
            width: 150,
            radius: 6,
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      ),
      const SizedBox(height: 8),
      Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          ShimmerBox(
            height: 500,
            radius: 15,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ShimmerBox(
                height: 200,
                width: 150,
                radius: 15,
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ShimmerBox(
          height: 20,
          width: 120,
          radius: 6,
        ),
      ),
    ]);
  }
}
