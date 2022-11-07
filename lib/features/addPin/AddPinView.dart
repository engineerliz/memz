import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/addPin/AddCaptionView.dart';
import 'package:memz/features/mainViews/MainViews.dart';
import 'package:memz/styles/fonts.dart';

import '../../components/map/CurrentLocationMap.dart';
import '../../components/scaffold/CommonAppBar.dart';
import '../../components/scaffold/PullToRefresh.dart';
import '../../styles/colors.dart';

class AddPinView extends StatefulWidget {
  @override
  AddPinViewState createState() => AddPinViewState();
}

class AddPinViewState extends State<AddPinView> {
  User? user = FirebaseAuth.instance.currentUser;

  late LatLng currentLocation = LatLng(0, 0);
  late bool isLoading = true;
  String? picPath;

  @override
  initState() {
    getCurrenLocation();
    super.initState();
  }

  void getCurrenLocation() {
    Future.delayed(Duration.zero, () async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        isLoading = false;
      });
    });
  }

  final captionController = TextEditingController();

  getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        picPath = image.path;
      });
    }
  }

  getImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        picPath = image.path;
      });
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: CommonScaffold(
        appBar: CommonAppBar(
          title: 'Drop a Pin',
          rightWidget: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                'Next',
                style: SubHeading.SH14,
              ),
            ),
            onTap: () {
              if (user?.uid != null && currentLocation.latitude != 0) {
                // PinStore.addPin(
                // creatorId: user!.uid,
                // location: currentLocation,
                // caption: captionController.text,
                // imgUrls: picPath != null ? [picPath!] : null,
                // );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddCaptionView(
                      creatorId: user!.uid,
                      location: currentLocation,
                      imgUrls: picPath != null ? [picPath!] : null,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        title: 'Drop a Pin',
        body: PullToRefresh(
            onRefresh: getCurrenLocation,
            body: ListView(children: [
              Column(
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8),
                      //   child: TextField(
                      //     controller: captionController,
                      //     decoration: const InputDecoration(
                      //       border: OutlineInputBorder(),
                      //       labelText: 'Caption',
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  if (picPath != null)
                    Container(child: Image.file(File(picPath!))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: getImageFromCamera,
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(MColors.white),
                        ),
                        child: Text(
                          'Camera',
                          style: SubHeading.SH18.copyWith(color: MColors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: getImageFromGallery,
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(MColors.white),
                        ),
                        child: Text(
                          'Camera Roll',
                          style: SubHeading.SH18.copyWith(color: MColors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ])),
      ),
    );
  }
}
