import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/follow/FollowStore.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/editProfile/EditProfileView.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/map/MultiPinMap.dart';
import 'ProfileAboutTab.dart';
import 'ProfilePinsTab.dart';

class UserProfileView extends StatefulWidget {
  final String? userId;

  const UserProfileView({
    super.key,
    this.userId,
  });

  @override
  UserProfileViewState createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView> {
  String? profileUserId;
  UserModel? userData;
  List<PinModel>? _userPins;
  TabController? tabController;
  bool isMyProfile = true;
  bool isFollowing = false;

  @override
  void initState() {
    print('widget.userId ${widget.userId}');
    setState(() {
      isMyProfile = widget.userId == null;
      profileUserId = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;
    });
    if (profileUserId != null) {
      UserStore.getUserById(id: profileUserId!).then(
        (value) => setState(() {
          userData = value;
        }),
      );
    }
    PinStore.getPinsByUserId(userId: profileUserId!).then(
      (value) => setState(() {
        _userPins = value;
      }),
    );
    if (!isMyProfile) {
      FollowStore.isFollowing(
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        followingId: widget.userId!,
      ).then((value) => setState(() {
            isFollowing = value == true;
          }));
    }
    super.initState();
  }

  String getTitle() {
    if (isMyProfile) {
      return 'My Profile';
    }
    return userData?.username ?? 'Profile';
  }

  GestureDetector? getRightWidget(BuildContext context, UserModel? userData) {
    print('isMyProfile $isMyProfile');
    if (isMyProfile == true) {
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
    } else {
      return GestureDetector(
        child: Text(
          isFollowing ? 'Unfollow' : 'Follow',
          style: SubHeading.SH14
              .copyWith(color: isFollowing ? MColors.grayV3 : MColors.green),
        ),
        onTap: () {
          FollowStore.followUser(
            userId: FirebaseAuth.instance.currentUser?.uid ?? '',
            followingId: widget.userId!,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: getTitle(),
      appBar: CommonAppBar(
        title: getTitle(),
        rightWidget: getRightWidget(context, userData),
      ),
      padding: const EdgeInsets.only(left: 0, right: 0),
      activeTab: 2,
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: MultiPinMap(
              pins: _userPins ?? [],
              isLoading: _userPins == null,
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
                        vertical: 12,
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
