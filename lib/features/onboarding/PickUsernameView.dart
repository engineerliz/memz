import 'package:flutter/material.dart';

class PickUsernameView extends StatefulWidget {
  @override
  PickUsernameViewState createState() => PickUsernameViewState();
}

class PickUsernameViewState extends State<PickUsernameView> {
  final FocusNode usernameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          usernameFocusNode.unfocus();
        },
        child: Scaffold());
  }
}
