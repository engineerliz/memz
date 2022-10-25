import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/map/style.dart';

import '../../api/pins/PinModel.dart';
import '../../utils/locationUtils.dart';
import 'landmarks.dart';

class MultiPinMap extends StatefulWidget {
  final List<PinModel> pins;
  final LatLng? location;
  final bool? isLoading;

  const MultiPinMap({
    super.key,
    required this.pins,
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

  var mapCenter = nycWSP;
  late List<LatLng>? pinsLatLngList;

  late Set<Marker> markerSet = {};

  @override
  initState() {
    setState(() {
      currentLocation = widget.location != null ? widget.location! : nycWSP;
      pinsLatLngList = List.from(widget.pins!.map((pin) => pin.location));

      mapCenter = getLatLngCenterFromList(pinsLatLngList!);
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(20, 20)),
            'assets/pin-emoji.png')
        .then((onValue) {
      setState(() {
        mapIcon = onValue;
        markerSet = Set.from(
          widget.pins.map(
            (pin) => Marker(
              markerId: MarkerId(pin.id),
              position: pin.location,
              icon: mapIcon,
            ),
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? const SizedBox(child: Text('Loading...'))
        : GoogleMap(
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: mapCenter,
              zoom: 5,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              controller.setMapStyle(mapStyle);
            },
            markers: markerSet,
          );
  }
}
