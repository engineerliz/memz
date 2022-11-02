import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/follow/FollowModel.dart';
import 'package:memz/api/follow/FollowStore.dart';
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
  @override
  MyProfileViewState createState() => MyProfileViewState();
}

class MyProfileViewState extends State<MyProfileView> {
  String? userId;
  UserModel? userData;
  List<PinModel>? _userPins;
  TabController? tabController;
  bool isMyProfile = true;
  bool isFollowing = false;
  FollowStatus followStatus = FollowStatus.none;
  List<String>? followersList;
  List<String>? followingList;

  @override
  void initState() {
    setState(() {
      userId = FirebaseAuth.instance.currentUser?.uid;
    });
    if (userId != null) {
      UserStore.getUserById(id: userId!).then(
        (value) => setState(() {
          userData = value;
        }),
      );
      PinStore.getPinsByUserId(userId: userId!).then(
        (value) => setState(() {
          _userPins = value;
        }),
      );

      FollowStore.getFollowerUsers(userId: userId!).then(
        (value) => setState(() {
          if (value != null) {
            followersList = List.from(value.map((follower) => follower.userId));
          }
        }),
      );

      FollowStore.getFollowingUsers(userId: userId!).then(
        (value) => setState(() {
          if (value != null) {
            followingList =
                List.from(value.map((follower) => follower.followingId));
          }
        }),
      );
    }
    super.initState();
  }

  GestureDetector? getRightWidget(BuildContext context, UserModel? userData) {
    return GestureDetector(
      child: Opacity(
        opacity: 0.8,
        child: Text(
          EmojiParser().get('gear').code,
          style: SubHeading.SH26,
        ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditProfileView(user: userData),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'My Profile',
      appBar: CommonAppBar(
        title: 'My Profile',
        rightWidget: getRightWidget(context, userData),
      ),
      padding: const EdgeInsets.only(left: 0, right: 0),
      activeTab: 2,
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: MultiPinMap(
              pins: _userPins != null ? _userPins! : [],
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    physics: const BouncingScrollPhysics(),
                    tabs: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Text(EmojiParser().get('round_pushpin').code,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(
                              width: 6,
                            ),
                            Text('${_userPins?.length ?? 0} pins',
                                style: SubHeading.SH14)
                          ],
                        ),
                      ),
                      SizedBox(
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
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: TabBarView(
                        children: [
                          ListView(
                            children: [
                              ProfilePinsTab(pins: _userPins),
                              const SizedBox(height: 40),
                            ],
                          ),
                          ListView(
                            children: [
                              ProfileAboutTab(
                                username: userData?.username,
                                homebase: userData?.homeBase,
                                friendsCount: 81,
                                joinDate: userData?.joinDate,
                                pinCount: _userPins?.length,
                                followersList: followersList,
                                followingList: followingList,
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
