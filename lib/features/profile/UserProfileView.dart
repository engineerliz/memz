import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/follow/FollowModel.dart';
import 'package:memz/api/follow/FollowStore.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/profile/utils/getProfileData.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/map/MultiPinMap.dart';
import '../../components/scaffold/PullToRefresh.dart';
import 'ProfileAboutTab.dart';
import 'ProfilePinsTab.dart';

class UserProfileView extends StatefulWidget {
  final String userId;

  const UserProfileView({
    super.key,
    required this.userId,
  });

  @override
  UserProfileViewState createState() => UserProfileViewState();
}

class UserProfileViewState extends State<UserProfileView> {
  String currentUserId = '';
  UserModel? userData;
  List<PinModel>? _userPins;
  TabController? tabController;
  bool pinsLoading = true;
  FollowStatus followStatus = FollowStatus.none;
  List<String>? followersList;
  List<String>? followingList;

  @override
  void initState() {
    setState(() {
      currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    });
    getProfileUserData(widget.userId).then((profileData) {
      setState(() {
        userData = profileData.userData;
        followersList = profileData.followersList;
        followingList = profileData.followingList;
      });
    });

    PinStore.getPinsByUserId(userId: widget.userId).then(
      (value) => setState(() {
        _userPins = value;
      }),
        )
        .whenComplete(
          () => setState(() {
            pinsLoading = false;
          }),
        );
    ;

    FollowStore.getFollowStatus(
      userId: currentUserId,
      followingId: widget.userId,
    ).then(
      (value) => setState(() {
        followStatus = value;
      }),
    );

    super.initState();
  }

  onRefresh() {
    setState(() {
      pinsLoading = true;
    });
    PinStore.getPinsByUserId(userId: widget.userId)
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
    getProfileUserData(widget.userId).then((profileData) {
      setState(() {
        userData = profileData.userData;
        followersList = profileData.followersList;
        followingList = profileData.followingList;
      });
    });
  }

  String getTitle() {
    return userData?.username ?? 'Profile';
  }

  GestureDetector? getRightWidget(BuildContext context, UserModel? userData) {
    Widget label = Text(
      'Follow',
      style: SubHeading.SH14.copyWith(color: MColors.green),
    );
    if (followStatus == FollowStatus.requested) {
      label = Text(
        'Requested',
        style: SubHeading.SH14.copyWith(color: MColors.grayV5),
      );
    } else if (followStatus == FollowStatus.following) {
      label = Text(
        'Unfollow',
        style: SubHeading.SH14.copyWith(color: MColors.grayV5),
      );
    }
    return GestureDetector(
      child: label,
      onTap: () {
        switch (followStatus) {
          case FollowStatus.following:
          case FollowStatus.requested:
            FollowStore.unfollowUser(
              userId: currentUserId,
              followingId: widget.userId,
            );
            setState(() {
              followStatus = FollowStatus.none;
            });
            break;
          case FollowStatus.none:
            FollowStore.requestFollowUser(
              userId: currentUserId,
              followingId: widget.userId,
            );
            setState(() {
              followStatus = FollowStatus.requested;
            });
        }
      },
    );
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
      ),
    );
  }
}
