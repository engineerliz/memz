import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/map/Map.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:intl/intl.dart';

import '../../api/users/UserModel.dart';
import '../../features/profile/UserProfileView.dart';

class PinPost extends StatefulWidget {
  final PinModel pin;
  final bool? withTap;

  PinPost({
    required this.pin,
    this.withTap = true,
  });
  @override
  State<PinPost> createState() => PinPostState();
}

class PinPostState extends State<PinPost> {
  UserModel? userData;
  @override
  void initState() {
    UserStore.getUserById(id: widget.pin.creatorId).then(
      (value) => setState(() {
        userData = value;
      }),
    );
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
          Row(
            children: [
              Text(
                userData?.emoji != null ? userData!.emoji! : Emojis.wavingHand,
                  style: SubHeading.SH22,
                ),
                const SizedBox(width: 6),
                Text(userData?.username ?? '', style: Heading.H14),
                const SizedBox(
                  width: 4,
              ),
              ],
          ),
          if (widget.pin.caption?.isNotEmpty == true)
            Text(widget.pin.caption!, style: Paragraph.P14),
          const SizedBox(height: 8),
          widget.pin.imgUrls != null
              ? getPostBodyWithPics()
              : getPostBodyWithoutPics(),
          const SizedBox(height: 8),
          Text(
            'Posted ${DateFormat.yMMMd().format(widget.pin.creationTime)}',
            style: SubHeading.SH14.copyWith(color: MColors.grayV5),
          )

        ],
      ),
    );
  }
}
