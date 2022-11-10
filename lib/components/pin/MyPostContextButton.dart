import 'package:flutter/material.dart';

import '../../api/pins/PinModel.dart';
import '../../api/pins/PinStore.dart';
import '../../styles/colors.dart';
import '../button/Button.dart';

class MyPostContextButton extends StatelessWidget {
  final PinModel pin;
  final VoidCallback? onRefresh;

  MyPostContextButton({
    required this.pin,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(2),
      visualDensity: VisualDensity.compact,
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
              color: MColors.background,
              child: Center(
                child: Button(
                  label: 'Delete Post',
                  onTap: () {
                    PinStore.deletePinById(pinId: pin.id).whenComplete(
                      () {
                        Navigator.pop(context);
                        if (onRefresh != null) onRefresh!();
                      },
                    );
                  },
                  type: ButtonType.secondary,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
