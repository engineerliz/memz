import '../../../api/follow/FollowStore.dart';
import '../../../api/users/UserModel.dart';
import '../../../api/users/UserStore.dart';

class ProfileUserData {
  late final UserModel? userData;
  late final List<String>? followersList;
  late final List<String>? followingList;

  ProfileUserData({
    required this.userData,
    required this.followersList,
    required this.followingList,
  });
}

Future<ProfileUserData> getProfileUserData(String userId) async {
  UserModel? userData;
  List<String>? followersList = [];
  List<String>? followingList = [];

  await UserStore.getUserById(id: userId).then(
    (value) {
      userData = value;
    },
  );

  await FollowStore.getUsersFollowers(userId: userId).then(
    (value) {
      if (value != null) {
        followersList = List.from(value.map((follower) => follower.userId));
      }
    },
  );

  await FollowStore.getUsersFollowing(userId: userId).then(
    (value) => {
      if (value != null)
        {
          followingList =
              List.from(value.map((follower) => follower.followingId))
        }
    },
  );

  return ProfileUserData(
    userData: userData,
    followersList: followersList,
    followingList: followingList,
  );
}
