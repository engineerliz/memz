import 'package:flutter/material.dart';

import '../../../api/pins/PinModel.dart';
import '../../../components/pin/PinPost.dart';

class ProfilePinsTab extends StatelessWidget {
  final List<PinModel>? pins;

  const ProfilePinsTab({
    super.key,
    this.pins,
  });

  @override
  Widget build(BuildContext context) {
    return pins != null
        ? ListView(
            children: [
              ...pins!.map(
                (pin) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: PinPost(
                    pin: pin,
                    withTap: false,
                  ),
                ),
              )
            ],
          )
        : const SizedBox();
  }
}
