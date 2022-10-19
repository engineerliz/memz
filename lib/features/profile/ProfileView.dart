import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/MUser.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/CommonScaffold.dart';
import 'package:memz/features/editProfile/EditProfileView.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  User? user = FirebaseAuth.instance.currentUser;

  final Future<MUser?> mUser =
      UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid ?? '');

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: 'My Profile',
        activeTab: 2,
        body: Column(
          children: [
            FutureBuilder<MUser?>(
              future: mUser, // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<MUser?> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 20,
                    ),
                    Stack(children: [
                      Expanded(
                          child: Text('Result: ${snapshot.data?.toJson()}'))
                    ]),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileView(user: snapshot.data),
                        ),
                      ),
                      child: const Text('Edit'),
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(MColors.grayV9),
                      ),
                    ),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
            Row(
              children: [
                const Text('👋', style: TextStyle(fontSize: 22)),
                const SizedBox(
                  width: 6,
                ),
                Text(user?.displayName ?? '', style: SubHeading.SH14)
              ],
            ),
            Row(
              children: [
                const Text('🏠', style: TextStyle(fontSize: 22)),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  'Los Angeles, California',
                  style: SubHeading.SH14,
                )
              ],
            ),
            Row(
              children: [
                const Text('🎉', style: TextStyle(fontSize: 22)),
                const SizedBox(
                  width: 6,
                ),
                Text('81 friends', style: SubHeading.SH14)
              ],
            ),
            Row(
              children: [
                const Text('🎁', style: TextStyle(fontSize: 22)),
                const SizedBox(
                  width: 6,
                ),
                Text('Joined Aug 22, 2022', style: SubHeading.SH14)
              ],
            ),
          ],
        ));
  }
}
