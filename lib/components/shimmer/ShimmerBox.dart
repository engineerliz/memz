import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../styles/colors.dart';

class ShimmerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;

  ShimmerBox({
    this.height,
    this.width,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: MColors.grayV9,
      highlightColor: MColors.background,
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          color: MColors.grayV9,
        ),
      ),
    );
  }
}
