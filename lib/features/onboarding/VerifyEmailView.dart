import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/styles/colors.dart';

import '../../screens/authentication/email_password/sign_in_screen.dart';
import '../../styles/fonts.dart';

class VerifyEmailView extends StatefulWidget {
  @override
  VerifyEmailViewState createState() => VerifyEmailViewState();
}

class VerifyEmailViewState extends State<VerifyEmailView> {
  late bool _isEmailVerified;
  bool _verificationEmailBeingSent = false;
  late User? _user;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    _isEmailVerified = _user?.emailVerified ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.background,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Image.asset(
                  'assets/SMYL_logo.png',
                  height: 60,
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please verify your email to get started',
                      style: Heading.H26,
                    ),
                    const SizedBox(height: 20),
                    _verificationEmailBeingSent
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MColors.grayV3,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _verificationEmailBeingSent = true;
                              });
                              await _user!.sendEmailVerification();
                              setState(() {
                                _verificationEmailBeingSent = false;
                              });
                            },
                            child: Text('Resend verification email',
                                style: SubHeading.SH14),
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  MColors.grayV9),
                            ),
                          ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  if (Navigator.canPop(context)) {
                    print('canPop!');
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ));
                },
                child: Text(
                  'Sign in with a different account',
                  style: SubHeading.SH14.copyWith(color: MColors.grayV3),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
