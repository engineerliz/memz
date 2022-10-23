import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/components/CommonScaffold.dart';
import 'package:memz/components/map/landmarks.dart';
import 'package:memz/styles/fonts.dart';

import '../../components/map/Map.dart';
import '../../styles/colors.dart';

class AddPinView extends StatefulWidget {
  @override
  AddPinViewState createState() => AddPinViewState();
}

class AddPinViewState extends State<AddPinView> {
  late LatLng currentLocation = LatLng(0, 0);
  late bool isLoading = true;
  @override
  initState() {
    Future.delayed(Duration.zero, () async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    });
    super.initState();
  }

  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('currentLocation $currentLocation');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CommonScaffold(
      title: 'Add Pin',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your current location', style: Heading.H14),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: isLoading
                      ? const SizedBox(child: Text('Loading...'))
                      : MapSample(
                          location: currentLocation,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Comments',
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => {},
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(MColors.white),
              ),
              child: Text(
                'Post Pin',
                style: SubHeading.SH18.copyWith(color: MColors.black),
              ),

            )
          ],
      ),
      ),
    );
  }
}
