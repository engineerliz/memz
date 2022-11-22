import 'package:flutter/material.dart';
import 'package:memz/components/pin/PinPost.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/map/Map.dart';

import '../../api/pins/PinModel.dart';
import '../../api/users/UserModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Define a custom Form widget.
class PinPostView extends StatefulWidget {
  final PinModel pin;

  const PinPostView({
    super.key,
    required this.pin,
  });

  @override
  State<PinPostView> createState() => _PinPostViewState();
}

class _PinPostViewState extends State<PinPostView> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    return CommonScaffold(
      title: '',
      body: Column(children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 500,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: [
            Container(
              clipBehavior: Clip.hardEdge,
              // width: MediaQuery.of(context).size.width,
              // height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.pin.imgUrls!.first),
                ),
              ),
            ),
            Container(
              height: 200,
              // width: 150,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Map(
                location: widget.pin.location,
                zoom: 11,
                // onTap: (latlng) {
                //   onPostTap();
                // },
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [1, 2].asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
