import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/CommonScaffold.dart';

import '../../components/map/Map.dart';

class AddPinView extends StatefulWidget {
  @override
  AddPinViewState createState() => AddPinViewState();
}

class AddPinViewState extends State<AddPinView> {
  late final Position currentLocation;
  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = position;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('currentLocation $currentLocation');
    return CommonScaffold(
      title: 'Add Pin',
      body: Container(
        height: 300,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: MapSample(
          location: LatLng(currentLocation.latitude, currentLocation.longitude),
        ),
      ),
    );
  }
}
