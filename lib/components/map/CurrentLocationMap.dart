import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/map/style.dart';
import 'package:memz/components/shimmer/ShimmerBox.dart';

import 'landmarks.dart';

class CurrentLocationMap extends StatefulWidget {
  final LatLng? location;
  final bool? isLoading;

  const CurrentLocationMap({
    super.key,
    this.location,
    this.isLoading = false,
  });

  @override
  State<CurrentLocationMap> createState() => CurrentLocationMapState();
}

class CurrentLocationMapState extends State<CurrentLocationMap> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLocation;
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

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? ShimmerBox()
        : GoogleMap(
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: currentLocation!,
              zoom: 11,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(mapStyle);
            },
            markers: {
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: currentLocation!,
                icon: mapIcon,
              )
            },
          );
  }
}
