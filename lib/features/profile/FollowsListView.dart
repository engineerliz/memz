import 'package:flutter/material.dart';
import 'package:memz/api/users/UserModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/user/UserTile.dart';

import '../../api/follow/FollowModel.dart';

class FollowsListView extends StatefulWidget {
  final String title;
  final List<String> followList;

  const FollowsListView({
    required this.title,
    required this.followList,
  });

  @override
  FollowsListViewState createState() => FollowsListViewState();
}

class FollowsListViewState extends State<FollowsListView> {
  List<UserModel> usersList = [];

  @override
  void initState() {
    for (String followId in widget.followList) {
      UserStore.getUserById(id: followId).then(
        (userData) {
          if (userData != null) {
            var newList = usersList;
            newList.add(userData);

            setState(() {
              usersList = newList;
            });
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: widget.title,
      body: Column(
        children: [
          ...usersList.map(
            (user) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: UserTile(user: user),
            ),
          )
        ],
      ),
    );
  }
}
