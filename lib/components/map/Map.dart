import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/map/style.dart';

import 'landmarks.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: nycWSP,
    zoom: 13,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(40.7580, 73.9855),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(mapStyle);
        });
    // return Scaffold(
    //   body: GoogleMap(
    //     mapType: MapType.normal,
    //     initialCameraPosition: _kGooglePlex,
    //     onMapCreated: (GoogleMapController controller) {
    //       _controller.complete(controller);
    //     },
    //   ),
    //   floatingActionButton: FloatingActionButton.extended(
    //     onPressed: _goToTheLake,
    //     label: const Text('To the lake!'),
    //     icon: const Icon(Icons.directions_boat),
    //   ),
    // );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
