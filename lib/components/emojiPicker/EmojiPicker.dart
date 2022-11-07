import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:emojis/emoji.dart';
import 'package:memz/styles/fonts.dart';

class EmojiPicker extends StatelessWidget {
  final Function(Emoji) onSelect;

  EmojiPicker({
    required this.onSelect,
  });

  Widget getSelectableEmoji(Emoji emoji) {
    return GestureDetector(
        onTap: () {
          onSelect(emoji);
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text(emoji.toString(), style: Branding.H32),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [...Emoji.all().map((emoji) => getSelectableEmoji(emoji))],
    );
  }
}
