import 'package:flutter/material.dart';

import '../styles/colors.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget? body;

  const CommonScaffold({
    super.key,
    required this.title,
    this.body,
  });

  void onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MColors.background,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 20.0,
        ),
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: onItemTapped,
      ),
    );
  }
}
