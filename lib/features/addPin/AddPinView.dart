import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/components/map/landmarks.dart';
import 'package:memz/features/mainViews/MainViews.dart';
import 'package:memz/styles/fonts.dart';

import '../../components/map/CurrentLocationMap.dart';
import '../../styles/colors.dart';
import '../profile/UserProfileView.dart';

class AddPinView extends StatefulWidget {
  @override
  AddPinViewState createState() => AddPinViewState();
}

class AddPinViewState extends State<AddPinView> {
  User? user = FirebaseAuth.instance.currentUser;

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

  final captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
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
                      : CurrentLocationMap(
                          location: currentLocation,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: captionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Caption',
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => {
                if (user?.uid != null && currentLocation.latitude != 0)
                  {
                    PinStore.addPin(
                      creatorId: user!.uid,
                      location: currentLocation,
                      caption: captionController.text,
                    ),
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MainViews(
                          activeTab: 0,
                        ),
                      ),
                    ),
                  }
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(MColors.white),
              ),
              child: Text(
                'Drop Pin',
                style: SubHeading.SH18.copyWith(color: MColors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
