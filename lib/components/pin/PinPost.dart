import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/map/Map.dart';
import 'package:memz/components/pin/MyPostContextButton.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:intl/intl.dart';

import '../../api/users/UserModel.dart';
import '../../features/profile/UserProfileView.dart';

class PinPost extends StatefulWidget {
  final PinModel pin;
  final bool? withTap;
  final bool? isLoading;

  PinPost({
    required this.pin,
    this.withTap = true,
    this.isLoading = false,
  });
  @override
  State<PinPost> createState() => PinPostState();
}

class PinPostState extends State<PinPost> {
  UserModel? userData;
  bool isMyPost = false;
  @override
  void initState() {
    UserStore.getUserById(id: widget.pin.creatorId).then(
      (value) => setState(() {
        userData = value;
      }),
    );

    if (FirebaseAuth.instance.currentUser?.uid == widget.pin.creatorId) {
      setState(() {
        isMyPost = true;
      });
    }

    super.initState();
  }

  void onTap() {
    if (userData != null && widget.withTap == true) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UserProfileView(
            userId: userData!.id,
          ),
        ),
      );
    }
  }

  Widget getPostBodyWithPics() {
    if (widget.pin.imgUrls != null) {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            width: MediaQuery.of(context).size.width,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.pin.imgUrls!.first),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                height: 200,
                width: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Map(
                  location: widget.pin.location,
                  zoom: 14,
                  onTap: (latlng) {
                    onTap();
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget getPostBodyWithoutPics() {
    return Container(
      height: 170,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Map(
          location: widget.pin.location,
          zoom: 13.5,
          onTap: (latlng) {
            onTap();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Text(
                  userData?.emoji != null
                      ? userData!.emoji!
                      : Emojis.wavingHand,
                  style: SubHeading.SH22,
                ),
                const SizedBox(width: 6),
                Text(userData?.username ?? '', style: Heading.H14),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
            if (isMyPost) MyPostContextButton(pin: widget.pin),
          ]),
          if (widget.pin.caption?.isNotEmpty == true)
            Text(widget.pin.caption!, style: Paragraph.P14),
          const SizedBox(height: 8),
          widget.pin.imgUrls != null
              ? getPostBodyWithPics()
              : getPostBodyWithoutPics(),
          const SizedBox(height: 8),
          Text(
            'Posted ${DateFormat.yMMMd().format(widget.pin.creationTime)}',
            style: SubHeading.SH12.copyWith(color: MColors.grayV5),
          )
        ],
      ),
    );
  }
}
