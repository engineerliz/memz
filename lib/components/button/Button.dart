import 'package:flutter/material.dart';

import '../../styles/colors.dart';
import '../../styles/fonts.dart';

enum ButtonType {
  primary,
  secondary,
  tertiary,
}

enum ButtonSize {
  xsmall,
  small,
  medium,
  large,
}

class Button extends StatelessWidget {
  final String label;
  final ButtonSize? size;
  final ButtonType? type;
  final VoidCallback? onTap;
  final double? width;
  final bool? fullWidth;

  Button({
    required this.label,
    this.size = ButtonSize.medium,
    this.type = ButtonType.primary,
    this.onTap,
    this.width,
    this.fullWidth = false,
  });

  Color getLabelColor() {
    switch (type) {
      case ButtonType.secondary:
        return MColors.white;
      case ButtonType.tertiary:
        return MColors.grayV3;
      case ButtonType.primary:
      default:
        return MColors.black;
    }
  }

  Color getButtonColor() {
    switch (type) {
      case ButtonType.secondary:
        return MColors.grayV9;
      case ButtonType.tertiary:
        return MColors.grayV9;
      case ButtonType.primary:
      default:
        return MColors.white;
    }
  }

  Widget getChild() {
    switch (size) {
      case ButtonSize.xsmall:
        return Text(label,
            style: SubHeading.SH12.copyWith(color: getLabelColor()));
      case ButtonSize.small:
        return Text(label,
            style: SubHeading.SH14.copyWith(color: getLabelColor()));
      case ButtonSize.large:
        return Text(label,
            style: SubHeading.SH22.copyWith(color: getLabelColor()));
      case ButtonSize.medium:
      default:
        return Text(label,
            style: SubHeading.SH18.copyWith(color: getLabelColor()));
    }
  }

  EdgeInsets getPadding() {
    switch (size) {
      case ButtonSize.xsmall:
        return EdgeInsets.symmetric(horizontal: 16, vertical: 0);
      case ButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16, vertical: 4);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 28, vertical: 12);
      case ButtonSize.medium:
      default:
        return EdgeInsets.symmetric(horizontal: 18, vertical: 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (fullWidth!) {
      return SizedBox.expand(
        child: ElevatedButton(
          onPressed: onTap,
          child: getChild(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: getPadding(),
            backgroundColor: getButtonColor(),
          ),
        ),
      );
    }
    if (width != null) {
      return SizedBox(
        width: width,
        child: ElevatedButton(
          onPressed: onTap,
          child: getChild(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: getPadding(),
            backgroundColor: getButtonColor(),
          ),
        ),
      );
    }
    return ElevatedButton(
      onPressed: onTap,
      child: getChild(),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        padding: getPadding(),
        backgroundColor: getButtonColor(),
      ),
    );
  }
}
