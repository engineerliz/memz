import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memz/styles/colors.dart';
import 'package:memz/styles/fonts.dart';

import '../../components/button/Button.dart';
import '../../components/map/CurrentLocationMap.dart';

class AddPinTile extends StatefulWidget {
  final LatLng? location;
  final bool? isLoading;

  AddPinTile({
    this.location,
    this.isLoading,
  });

  @override
  AddPinTileState createState() => AddPinTileState();
}

class AddPinTileState extends State<AddPinTile> {
  String? picPath;

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
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          width: MediaQuery.of(context).size.width,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MColors.grayV9,
            image: picPath != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(picPath!)),
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Add a picture', style: SubHeading.SH18),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    label: 'Camera',
                    onTap: getImageFromCamera,
                    type: ButtonType.primary,
                    size: ButtonSize.small,
                  ),
                  const SizedBox(width: 12),
                  Button(
                    label: 'Camera Roll',
                    onTap: getImageFromGallery,
                    type: ButtonType.primary,
                    size: ButtonSize.small,
                  ),
                ],
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            height: 200,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: CurrentLocationMap(
              location: widget.location,
              isLoading: widget.isLoading,
            ),
          ),
        ),
      ],
    );
  }
}
