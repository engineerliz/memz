import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/map/style.dart';

import 'landmarks.dart';

class MultiPinMap extends StatefulWidget {
  final LatLng? location;
  final bool? isLoading;

  const MultiPinMap({
    super.key,
    this.location,
    this.isLoading = false,
  });

  @override
  State<MultiPinMap> createState() => MultiPinMapState();
}

class MultiPinMapState extends State<MultiPinMap> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng currentLocation = nycWSP;
  late BitmapDescriptor mapIcon = BitmapDescriptor.defaultMarker;

  @override
  initState() {
    setState(() {
      currentLocation = widget.location != null ? widget.location! : nycWSP;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(20, 20)), 'assets/pin-emoji.png')
        .then((onValue) {
      setState(() {
        mapIcon = onValue;
      });
    });
    super.initState();
  }

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(40.7580, 73.9855),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? const SizedBox(child: Text('Loading...'))
        : GoogleMap(
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: widget.location ?? nycWSP,
              // target: nycWSP,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(mapStyle);
            },
            markers: {
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: widget.location ?? nycWSP,
                // position: nycWSP,
                icon: mapIcon,
              )
            },
          );
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
