import 'package:flutter/material.dart';
import 'package:memz/components/pin/PinPost.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';

import '../../api/pins/PinModel.dart';

class PinPostView extends StatelessWidget {
  final PinModel pin;

  const PinPostView({
    super.key,
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: '',
      body: PinPost(pin: pin),
    );
  }
}
