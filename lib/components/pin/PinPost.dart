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

class PinPost extends StatelessWidget {
  final PinModel pin;

  PinPost({
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    final Future<UserModel?> user = UserStore.getUserById(id: pin.creatorId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              EmojiParser().get('full_moon_with_face').code,
              style: SubHeading.SH22,
            ),
            const SizedBox(width: 6),
            FutureBuilder<UserModel?>(
              future: user,
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel?> userData) {
                if (userData.hasData) {
                  return Text(userData.data!.username, style: Heading.H14);
                }
                return const SizedBox();
              },
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'posted ${DateFormat.yMMMd().format(pin.creationTime)}',
              style: SubHeading.SH14.copyWith(color: MColors.grayV3),
            )
          ],
        ),
        const SizedBox(height: 2),
        if (pin.caption?.isNotEmpty == true) ...[
          Text(pin.caption!, style: Paragraph.P14),
          const SizedBox(height: 12)
        ],
        Container(
          height: 200,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Map(
            location: pin.location,
          ),
        ),
      ],
    );
  }
}
