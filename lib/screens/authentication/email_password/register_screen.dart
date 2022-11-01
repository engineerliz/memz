import 'package:flutter/material.dart';
import 'package:memz/styles/colors.dart';

import '../../../res/custom_colors.dart';
import '../../../styles/fonts.dart';
import '../../../widgets/app_bar_title.dart';
import '../../../widgets/authentication/email_password/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _nameFocusNode.unfocus();
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: MColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'assets/SMYL_logo.png',
                          height: 160,
                        ),
                      ),
                      Text(
                        'send me your location',
                        style: Branding.H22.copyWith(color: MColors.grayV3),
                      ),
                    ],
                  ),
                ),
                RegisterForm(
              nameFocusNode: _nameFocusNode,
              emailFocusNode: _emailFocusNode,
              passwordFocusNode: _passwordFocusNode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
