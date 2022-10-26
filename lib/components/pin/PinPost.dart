import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:memz/api/pins/PinModel.dart';
import 'package:memz/api/users/UserStore.dart';
import 'package:memz/components/map/CurrentLocationMap.dart';
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

  @override
  Widget build(BuildContext context) {
    // final Future<UserModel?> user =
    //     UserStore.getUserById(id: widget.pin.creatorId);

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
                  EmojiParser().get('full_moon_with_face').code,
                  style: SubHeading.SH22,
                ),
                const SizedBox(width: 6),
                Text(userData?.username ?? '', style: Heading.H14),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'posted ${DateFormat.yMMMd().format(widget.pin.creationTime)}',
                  style: SubHeading.SH14.copyWith(color: MColors.grayV3),
                )
              ],
            ),
            const SizedBox(height: 2),
            if (widget.pin.caption?.isNotEmpty == true) ...[
              Text(widget.pin.caption!, style: Paragraph.P14),
              const SizedBox(height: 12)
            ],
            Container(
              height: 200,
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
            ),
          ],
        ));
  }
}
