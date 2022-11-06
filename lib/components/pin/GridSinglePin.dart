import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinModel.dart';
import 'package:memz/components/map/Map.dart';
import 'package:memz/styles/colors.dart';

class GridSinglePin extends StatelessWidget {
  final PinModel pinData;

  const GridSinglePin({
    super.key,
    required this.pinData,
  });

  @override
  Widget build(BuildContext context) {
    if (pinData.imgUrls?.isNotEmpty == true) {
      return Container(
        height: MediaQuery.of(context).size.width * .65,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          border: Border.all(color: MColors.background),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(pinData.imgUrls!.first),
          ),
        ),
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
