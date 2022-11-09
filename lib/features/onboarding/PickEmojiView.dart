import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/emojiPicker/EmojiPickerView.dart';

import '../../styles/colors.dart';
import 'OnboardingSuccessView.dart';

class PickEmojiView extends StatefulWidget {
  @override
  PickEmojiViewState createState() => PickEmojiViewState();
}

class PickEmojiViewState extends State<PickEmojiView> {
  UserModel? user;

  @override
  void initState() {
    UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid)
        .then((value) {
      setState(() {
        user = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.background,
      body: EmojiPickerView(onSelect: (emoji) {
        UserStore.updateUser(
          user: user!,
          newEmoji: emoji.toString(),
        ).whenComplete(
          () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => OnboardingSuccessView(),
            ),
          ),
        );
      }),
    );
  }
}
