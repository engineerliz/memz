import 'package:flutter/material.dart';

import '../../api/pins/PinModel.dart';
import '../../api/pins/PinStore.dart';
import '../../styles/colors.dart';

class MyPostContextButton extends StatelessWidget {
  final PinModel pin;

  MyPostContextButton({
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.more_vert,
        color: MColors.grayV5,
        size: 22,
      ),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 120,
              color: MColors.grayV9,
              child: Center(
                child: ElevatedButton(
                  child: const Text('Delete Post'),
                  onPressed: () {
                    PinStore.deletePinById(pinId: pin.id).whenComplete(
                      () => Navigator.pop(context),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
