import 'package:flutter/material.dart';
import 'package:memz/screens/authentication/email_password/sign_in_screen.dart';

import 'screens/main_screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire Samples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'OpenSans',
      ),
      // home: SignInScreen(),
      home: const HomeScreen(),
    );
  }
}
