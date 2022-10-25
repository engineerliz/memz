import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/editProfile/EditProfileView.dart';
import 'package:memz/styles/fonts.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/map/MultiPinMap.dart';
import 'ProfileAboutTab.dart';
import 'ProfilePinsTab.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  MyProfileViewState createState() => MyProfileViewState();
}

class MyProfileViewState extends State<MyProfileView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userData;
  List<PinModel>? userPins;

  final Future<UserModel?> userFuture =
      UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid ?? '');

  final Future<List<PinModel>?> userPinsFuture = PinStore.getPinsByUserId(
      userId: FirebaseAuth.instance.currentUser?.uid ?? '');

  var parser = EmojiParser();
  TabController? tabController;

  @override
  void initState() {
    userFuture.then(
      (value) => setState(() {
        userData = value;
      }),
    );
    userPinsFuture.then(
      (value) => setState(() {
        userPins = value;
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
      padding: const EdgeInsets.only(left: 0, right: 0),
      activeTab: 2,
      body: Column(
        children: [
          Container(
            height: 200,
            child: MultiPinMap(),
          ),
          Expanded(
            child: DefaultTabController(
              length: 5,
              child: Column(
                children: [
                  TabBar(
                    physics: const BouncingScrollPhysics(),
                    tabs: [
                      Container(
                          height: 50,
                          child: Row(
                            children: [
                              const Text('👋', style: TextStyle(fontSize: 22)),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(userData?.username ?? '',
                                  style: SubHeading.SH14)
                            ],
                          )),
                      Row(
                        children: [
                          Text(EmojiParser().get('round_pushpin').code,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(
                            width: 6,
                          ),
                          Text('${userPins?.length ?? 0} pins',
                              style: SubHeading.SH14)
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            ProfileAboutTab(
                              username: userData?.username,
                              homebase: userData?.homeBase,
                              friendsCount: 81,
                              joinDate: userData?.joinDate,
                              pinCount: userPins?.length,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                        // ),
                        ListView(children: [
                          ProfilePinsTab(pins: userPins),
                          const SizedBox(height: 40),
                        ])
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
