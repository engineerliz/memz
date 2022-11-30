import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinModel.dart';

import '../../../components/pin/GridSinglePin.dart';

class PinsGridView extends StatelessWidget {
  final List<PinModel> pins;

  const PinsGridView({
    super.key,
    required this.pins,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: .7,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: List.generate(
        pins.length,
        (index) {
          return GridSinglePin(
            pinData: pins[index],
          );
        },
      ),
    );
  }
}
