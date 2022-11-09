import 'package:flutter/material.dart';
import 'package:emojis/emojis.dart';
import 'package:emojis/emoji.dart';
import 'package:memz/components/emojiPicker/EmojiPicker.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/styles/fonts.dart';

class EmojiPickerView extends StatelessWidget {
  final Function(Emoji) onSelect;

  EmojiPickerView({
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Pick an Emoji',
      body: ListView(children: [EmojiPicker(onSelect: onSelect)]),
    );
  }
}
