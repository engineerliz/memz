import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/pin/PinPost.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/map/Map.dart';

import '../../api/pins/PinModel.dart';
import '../../api/users/UserModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

// Define a custom Form widget.
class MapView extends StatefulWidget {
  final LatLng latLng;

  const MapView({
    super.key,
    required this.latLng,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
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
      padding: const EdgeInsets.all(0),
      title: '',
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Map(
          hasGestures: true,
          location: widget.latLng,
        ),
      ),
    );
  }
}
