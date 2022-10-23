import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/MUser.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/CommonScaffold.dart';
import 'package:memz/features/editProfile/EditProfileView.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:intl/intl.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

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
              future: mUser, 
              builder: (BuildContext context, AsyncSnapshot<MUser?> userData) {
                List<Widget> children;
                if (userData.hasData) {
                  children = <Widget>[
                    // const Icon(
                    //   Icons.check_circle_outline,
                    //   color: Colors.green,
                    //   size: 20,
                    // ),
                    // Text('Result: ${userData.data?.toJson()}'),
                    Row(
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 22)),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(userData.data?.username ?? '',
                            style: SubHeading.SH14)
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text('🏠', style: TextStyle(fontSize: 22)),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          userData.data?.homeBase ?? '',
                          style: SubHeading.SH14,
                        )
                      ],
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 22)),
                        const SizedBox(
                          width: 6,
                        ),
                        Text('[Static] 81 friends', style: SubHeading.SH14)
                      ],
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Text('🎁', style: TextStyle(fontSize: 22)),
                        const SizedBox(
                          width: 6,
                        ),
                        if (userData.data?.joinDate != null)
                          Text(
                              'Joined ${DateFormat.yMMMd().format(userData.data!.joinDate!)}',
                              style: SubHeading.SH14)
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileView(user: userData.data),
                        ),
                      ),
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(MColors.grayV9),
                      ),
                      child: Text('Edit', style: SubHeading.SH18),
                    ),

                  ];
                } else if (userData.hasError) {
                  children = <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${userData.error}'),
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
          ],
        ));
  }
}
