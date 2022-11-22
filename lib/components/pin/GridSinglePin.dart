import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinModel.dart';
import 'package:memz/components/map/Map.dart';
import 'package:memz/styles/colors.dart';

import '../shimmer/ShimmerBox.dart';

class GridSinglePin extends StatelessWidget {
  final PinModel pinData;

  const GridSinglePin({
    super.key,
    required this.pinData,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.width * .65;
    double width = MediaQuery.of(context).size.width / 2;
    if (pinData.imgUrls?.isNotEmpty == true) {
      return Container(
        height: MediaQuery.of(context).size.width * .65,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          border: Border.all(color: MColors.background),
          ),
          child: CachedNetworkImage(
            height: height,
            width: width,
            fit: BoxFit.cover,
            imageUrl: pinData.imgUrls!.first,
            placeholder: (context, url) => ShimmerBox(
              height: height,
              radius: width,
            ),
          )
      );
    }
    return Container(
      height: MediaQuery.of(context).size.width * .65,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        border: Border.all(color: MColors.background),
      ),
      child: Map(
        location: pinData.location,
        zoom: 14,
      ),
    );
  }
}
