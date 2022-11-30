import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/scaffold/PullToRefresh.dart';
import 'package:memz/features/editProfile/EditProfileView.dart';
import 'package:memz/features/profile/tabs/PinsGridView.dart';
import 'package:memz/features/profile/utils/getProfileData.dart';
import 'package:memz/styles/fonts.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/map/MultiPinMap.dart';
import 'tabs/ProfileAboutTab.dart';
import 'tabs/ProfilePinsTab.dart';

class MyProfileView extends StatefulWidget {
  @override
  MyProfileViewState createState() => MyProfileViewState();
}

class MyProfileViewState extends State<MyProfileView> {
  String? userId;
  UserModel? userData;
  List<PinModel>? _userPins;
  bool pinsLoading = true;
  TabController? tabController;
  List<String>? followersList;
  List<String>? followingList;

  @override
  void initState() {
    setState(() {
      userId = FirebaseAuth.instance.currentUser?.uid;
    });
    if (userId != null) {
      getProfileUserData(userId!).then((profileData) {
        setState(() {
          userData = profileData.userData;
          followersList = profileData.followersList;
          followingList = profileData.followingList;
        });
      });
      PinStore.getPinsByUserId(userId: userId!)
          .then(
            (value) => setState(() {
              _userPins = value;
            }),
          )
          .whenComplete(
            () => setState(() {
              pinsLoading = false;
            }),
          );
    }
    super.initState();
  }

  onRefresh() {
    setState(() {
      pinsLoading = true;
    });
    PinStore.getPinsByUserId(userId: userId!)
        .then(
          (value) => setState(() {
            _userPins = value;
          }),
        )
        .whenComplete(
          () => setState(() {
            pinsLoading = false;
          }),
        );
    if (userId != null) {
      getProfileUserData(userId!).then((profileData) {
        setState(() {
          userData = profileData.userData;
          followersList = profileData.followersList;
          followingList = profileData.followingList;
        });
      });
    }
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
      body: PullToRefresh(
        onRefresh: onRefresh,
        body: Column(
          children: [
            if (!pinsLoading)
              SizedBox(
                height: 200,
                child: MultiPinMap(
                  pins: _userPins != null ? _userPins! : [],
                  isLoading: pinsLoading,
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
                              Text(
                                  userData?.emoji != null
                                      ? userData!.emoji!
                                      : Emojis.wavingHand,
                                  style: TextStyle(fontSize: 22)),
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

                        child: TabBarView(
                        children: [
                          PinsGridView(pins: _userPins ?? []),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ListView(
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
                              )),
                          ],
                        ),
                      
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
