import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/editProfile/EditProfileView.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/pin/PinPost.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userData;

  final Future<UserModel?> userFuture =
      UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid ?? '');

  final Future<List<PinModel>?> userPins = PinStore.getPinsByUserId(
      userId: FirebaseAuth.instance.currentUser?.uid ?? '');

  var parser = EmojiParser();

  @override
  void initState() {
    userFuture.then(
      (value) => setState(() {
        userData = value;
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: 'My Profile',
        appBar: CommonAppBar(
          title: 'My Profile',
          rightWidget: GestureDetector(
            child: Opacity(
              opacity: 0.8,
              child: Text(
                parser.get('gear').code,
                style: SubHeading.SH26,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProfileView(user: userData),
              ),
            ),
          ),
        ),
        activeTab: 2,
        body: Column(
          children: [
            Row(
              children: [
                const Text('👋', style: TextStyle(fontSize: 22)),
                const SizedBox(
                  width: 6,
                ),
                Text(userData?.username ?? '', style: SubHeading.SH14)
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
                  userData?.homeBase ?? '',
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
                if (userData?.joinDate != null)
                  Text(
                      'Joined ${DateFormat.yMMMd().format(userData!.joinDate!)}',
                      style: SubHeading.SH14)
              ],
            ),
            const SizedBox(height: 40),

            FutureBuilder<List<PinModel>?>(
                future: userPins,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PinModel>?> pinsData) {
                  print('userPins ${pinsData.data}');
                  if (pinsData.hasData) {
                    return Column(
                      children: [
                        ...pinsData.data!.map(
                          (pin) => Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: PinPost(pin: pin),
                          ),
                        )
                      ],
                    );
                  }
                  return const SizedBox();
                }),
          ],
        ));
  }
}
