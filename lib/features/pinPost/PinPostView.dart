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
      body: PinPost(pin: widget.pin),
    );
  }
}
