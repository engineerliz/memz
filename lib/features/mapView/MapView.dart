import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/map/Map.dart';

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
    return CommonScaffold(
      padding: const EdgeInsets.all(0),
      title: '',
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Map(
          zoom: 12,
          hasGestures: true,
          location: widget.latLng,
        ),
      ),
    );
  }
}
