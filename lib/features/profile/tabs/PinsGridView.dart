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
    return Wrap(
      children: [
        ...pins.map(
          (pin) => GridSinglePin(
            pinData: pin,
          ),
        ),
      ],
    );
  }
}
