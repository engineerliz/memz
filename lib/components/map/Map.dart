import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/map/style.dart';

import 'landmarks.dart';

class Map extends StatefulWidget {
  final LatLng? location;
  final bool? isLoading;
  final bool? hasGestures;
  final Function(LatLng)? onTap;

  const Map({
    super.key,
    this.location,
    this.isLoading = false,
    this.hasGestures = false,
    this.onTap,
  });

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
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
            onTap: widget.onTap,
            zoomGesturesEnabled: widget.hasGestures == true,
            scrollGesturesEnabled: widget.hasGestures == true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: widget.location ?? nycWSP,
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
                icon: mapIcon,
              )
            },
          );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
