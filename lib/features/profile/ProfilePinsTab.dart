import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';

import '../../api/pins/PinModel.dart';
import '../../components/pin/PinPost.dart';
import '../../styles/fonts.dart';

class ProfilePinsTab extends StatelessWidget {
  final List<PinModel>? pins;

  const ProfilePinsTab({
    super.key,
    this.pins,
  });

  @override
  Widget build(BuildContext context) {
    return pins != null
        ? Column(
            children: [
              ...pins!.map(
                (pin) => Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: PinPost(pin: pin),
                ),
              )
            ],
          )
        : const SizedBox();
  }
}
