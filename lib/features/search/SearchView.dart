import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import '../../components/user/UserTile.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? userData;

  Future<List<UserModel>?>? userSearchFuture;

  var parser = EmojiParser();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: 'Search',
      activeTab: 2,
      body: Column(
        children: [
          TextField(
            onChanged: ((value) => setState(() {
                  userSearchFuture =
                      UserStore.searchUsersByUsername(username: value);
                })),
            controller: searchController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Find friends by username',
            ),
          ),
          const SizedBox(height: 30),
          FutureBuilder<List<UserModel>?>(
            future: userSearchFuture,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<UserModel>?> usersData,
            ) {
              if (usersData.data?.isNotEmpty == true) {
                return Column(
                  children: [
                    ...usersData.data!.map(
                      (user) => Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: UserTile(user: user),
                      ),
                    )
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: searchController.text.isEmpty
                      ? Text(
                          EmojiParser().get('people_holding_hands').code,
                          style: SubHeading.SH26,
                        )
                      : Column(
                          children: [
                            Text(
                              EmojiParser().get('shrug').code,
                              style: SubHeading.SH26,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'no matches',
                              style: SubHeading.SH14
                                  .copyWith(color: MColors.grayV5),
                            )
                          ],
                        ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
