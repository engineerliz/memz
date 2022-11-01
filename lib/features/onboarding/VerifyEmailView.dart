import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/features/onboarding/utils/authPathNavigator.dart';
import 'package:memz/styles/colors.dart';

import '../../api/users/UserStore.dart';
import '../../screens/authentication/email_password/sign_in_screen.dart';
import '../../styles/fonts.dart';
import '../../utilsBoilerplate/authentication/email_password_auth/authentication.dart';

class VerifyEmailView extends StatefulWidget {
  @override
  VerifyEmailViewState createState() => VerifyEmailViewState();
}

class VerifyEmailViewState extends State<VerifyEmailView> {
  bool _verificationEmailBeingSent = false;
  late User? _user;
  UserModel? userData;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      UserStore.getUserById(id: _user!.uid).then((value) {
        userData = value;
      });
    }

    if (_user?.emailVerified == true) {
      getAuthNavigation(
        context: context,
        isEmailVerified: _user?.emailVerified,
        user: userData,
      );
    }

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
                    ElevatedButton(
                      onPressed: () async {
                        User? user = await Authentication.refreshUser(_user!);
                        if (user?.emailVerified == true) {
                          getAuthNavigation(
                            context: context,
                            isEmailVerified: user?.emailVerified,
                            user: userData,
                          );
                        }
                      },
                      child: Text('I verified my email',
                          style:
                              SubHeading.SH18.copyWith(color: MColors.black)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        backgroundColor: MColors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _verificationEmailBeingSent
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              MColors.grayV3,
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                _verificationEmailBeingSent = true;
                              });
                              await _user!.sendEmailVerification();
                              setState(() {
                                _verificationEmailBeingSent = false;
                              });
                            },
                            child: Text(
                                'Didn\'t get an email?\nResend verification email',
                                style: SubHeading.SH14
                                    .copyWith(color: MColors.grayV3)),
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
                  style: SubHeading.SH14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
