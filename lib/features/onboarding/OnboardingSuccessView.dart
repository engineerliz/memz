import 'package:flutter/material.dart';
import 'package:memz/features/mainViews/MainViews.dart';

import '../../styles/colors.dart';
import '../../styles/fonts.dart';

class OnboardingSuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.background,
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 80, left: 20, right: 20, bottom: 50),
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
              Text('Welcome to SMYL', style: Branding.H32),
              Column(children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainViews(),
                      ),
                    );
                  },
                  child: Text('Get Started',
                      style: SubHeading.SH18.copyWith(color: MColors.black)),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      backgroundColor: MColors.white,
                      minimumSize: Size(double.infinity, 50)),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
