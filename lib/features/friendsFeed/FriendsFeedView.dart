import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonAppBar.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../api/pins/PinModel.dart';
import '../../components/pin/PinPost.dart';

class FriendsFeedView extends StatefulWidget {
  const FriendsFeedView({super.key});

  @override
  FriendsFeedViewState createState() => FriendsFeedViewState();
}

class FriendsFeedViewState extends State<FriendsFeedView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userData;

  final Future<UserModel?> userFuture =
      UserStore.getUserById(id: FirebaseAuth.instance.currentUser?.uid ?? '');

  final Future<List<PinModel>?> allPins = PinStore.getAllPins();

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
        title: 'Pinned',
        activeTab: 2,
        body: Column(
          children: [
            FutureBuilder<List<PinModel>?>(
                future: allPins,
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