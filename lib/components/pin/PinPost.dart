import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memz/api/pins/PinModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/map/Map.dart';
import 'package:memz/components/pin/MyPostContextButton.dart';
import 'package:memz/features/mapView/MapView.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../api/users/UserModel.dart';
import '../../features/profile/UserProfileView.dart';
import '../shimmer/ShimmerBox.dart';

class PinPost extends StatefulWidget {
  final PinModel pin;
  final bool? withTap;
  final bool? isLoading;
  final VoidCallback? onRefresh;

  PinPost({
    required this.pin,
    this.withTap = true,
    this.isLoading = false,
    this.onRefresh,
  });
  @override
  State<PinPost> createState() => PinPostState();
}

class PinPostState extends State<PinPost> {
  UserModel? userData;
  bool isMyPost = false;
  bool showMap = true;

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

  void onProfileTap() {
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

  void onPostTap() {
    setState(() {
      showMap = !showMap;
    });
  }

  void onMapTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapView(latLng: widget.pin.location),
      ),
    );
  }

  Widget getPostBodyWithPics() {
    if (widget.pin.imgUrls != null) {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.pin.imgUrls!.first,
              height: 500,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              placeholder: (context, url) => ShimmerBox(
                height: 500,
                radius: 15,
              ),
            ),
          ),
          if (showMap)
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
                    zoom: 11,
                    onTap: (latlng) {
                      onMapTap();
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
            onMapTap();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onProfileTap();
            },
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                if (isMyPost)
                  MyPostContextButton(
                    pin: widget.pin,
                    onRefresh: widget.onRefresh,
                  ),
              ]),
              if (widget.pin.caption?.isNotEmpty == true)
                Text(widget.pin.caption!, style: Paragraph.P14),
              const SizedBox(height: 8),
            ])),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onPostTap();
            },
            child: widget.pin.imgUrls != null
                ? getPostBodyWithPics()
                : getPostBodyWithoutPics()),
        const SizedBox(height: 8),
        Text(
          '${DateFormat.yMMMd().format(widget.pin.creationTime)} ${DateFormat.jm().format(widget.pin.creationTime)}',
          style: Paragraph.P12.copyWith(color: MColors.grayV5),
        )
      ],
    );
  }
}
