import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/follow/FollowStore.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/scaffold/PullToRefresh.dart';
import 'package:memz/features/search/SearchView.dart';
import 'package:memz/styles/fonts.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/pin/LoadingPinPost.dart';
import '../../components/pin/PinPost.dart';
import 'EmptyFeedMessage.dart';

class FriendsFeedView extends StatefulWidget {
  const FriendsFeedView({super.key});

  @override
  FriendsFeedViewState createState() => FriendsFeedViewState();
}

class FriendsFeedViewState extends State<FriendsFeedView> {
  bool isLoading = true;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userData;
  List<String> followingUsersIdList = [];

  final Future<UserModel?> userFuture =
      UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid ?? '');

  List<PinModel> pinsData = [];

  var parser = EmojiParser();

  @override
  void initState() {
    userFuture.then(
      (value) => setState(() {
        userData = value;
      }),
    );

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      FollowStore.getUsersFollowing(
              userId: FirebaseAuth.instance.currentUser!.uid)
          .then((followingList) {
        print('followingList $followingList');

        setState(() {
          followingUsersIdList = followingList
              .map((followModel) => followModel.followingId)
              .toList();
          followingUsersIdList.add(FirebaseAuth.instance.currentUser!.uid);
        });
        PinStore.getPinsFromFollowingList(followingUsersIdList).then((value) {
          pinsData = value;
        }).whenComplete(
          () => setState(() {
            isLoading = false;
          }),
        );
      });
    }

    super.initState();
  }

  void onRefresh() {
    setState(() {
      isLoading = true;
    });
    PinStore.getAllPins().then((value) {
      setState(() {
        pinsData = value;
        isLoading = false;
      });
    });
  }

  Widget getBody() {
    if (isLoading) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: LoadingPinPost(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: LoadingPinPost(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: LoadingPinPost(),
          ),
        ],
      );
    }
    if (pinsData.length == 0) {
      return EmptyFeedMessage();
    }
    return ListView(
      children: [
        ...pinsData.map(
          (pin) => Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: PinPost(
              pin: pin,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'SMYL${Emojis.roundPushpin}',
      appBar: CommonAppBar(
        title: 'SMYL${Emojis.roundPushpin}',
        rightWidget: GestureDetector(
          child: Opacity(
            opacity: 0.8,
            child: Text(
              parser.get('mag').code,
              style: SubHeading.SH26,
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SearchView(),
            ),
          ),
        ),
      ),
      body: PullToRefresh(onRefresh: onRefresh, body: getBody()),
    );
  }
}
