import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memz/api/pins/PinStore.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/mainViews/MainViews.dart';
import 'package:memz/styles/fonts.dart';

import '../../components/map/CurrentLocationMap.dart';
import '../../components/scaffold/CommonAppBar.dart';
import '../../components/scaffold/PullToRefresh.dart';
import '../../styles/colors.dart';

class AddCaptionView extends StatefulWidget {
  final String creatorId;
  final LatLng location;
  final List<String>? imgUrls;

  AddCaptionView({
    required this.creatorId,
    required this.location,
    this.imgUrls,
  });

  @override
  AddCaptionViewState createState() => AddCaptionViewState();
}

class AddCaptionViewState extends State<AddCaptionView> {
  final captionController = TextEditingController();

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
          title: 'Add a caption',
          rightWidget: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                'Post',
                style: SubHeading.SH14,
              ),
            ),
            onTap: () {
              PinStore.addPin(
                creatorId: widget.creatorId,
                location: widget.location,
                caption: captionController.text,
                imgUrls: widget.imgUrls,
              ).whenComplete(() {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainViews(
                      activeTab: 0,
                    ),
                  ),
                );
              });
            },
          ),
        ),
        title: 'Add a caption',
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: TextField(
            autofocus: true,
            controller: captionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Caption',
            ),
          ),
        ),
      ),
    );
  }
}
