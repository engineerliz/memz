import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memz/features/onboarding/PickEmojiView.dart';

import '../../../api/users/UserModel.dart';
import '../../../screens/authentication/email_password/sign_in_screen.dart';
import '../../mainViews/MainViews.dart';
import '../PickUsernameView.dart';
import '../VerifyEmailView.dart';

getAuthNavigation({
  required BuildContext context,
  UserModel? user,
  bool? isEmailVerified,
}) {
  if (user != null) {
    if (isEmailVerified != true) {
      print('email not verified');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => VerifyEmailView(),
      ));
      return;
    } else if (user.username == null) {
      print('no username');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PickUsernameView(),
      ));
      return;
    } else if (user.emoji == null) {
      print('no username');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PickEmojiView(),
      ));
      return;
    } else {
      print('normal user sign in');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MainViews(),
      ));
      return;
    }
  } else {
    print('user is null');

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SignInScreen(),
    ));
    return;
  }
}
