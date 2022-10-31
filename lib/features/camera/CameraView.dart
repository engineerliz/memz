import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:memz/components/scaffold/CommonScaffold.dart';
import 'package:memz/features/profile/SingleButtonBottomBar.dart';
import 'package:memz/styles/colors.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../../styles/fonts.dart';

class CameraView extends StatefulWidget {
  final Function(String) getFinalPic;

  CameraView({required this.getFinalPic});

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  String? picPath;
  CameraController? controller;
  bool _isCameraInitialized = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    // if (cameras[0] != null) {
    onNewCameraSelected(cameras[0]);
    clearPics();
    // }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  getPic() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    if (fileList.isNotEmpty) {
      setState(() {
        picPath = fileList.last.path;
      });
    }
    print('fileList ${fileList.length}');
    print('fileList ${fileList}');
    // return fileList.first.;
  }

  clearPics() async {
    final directory = await getApplicationDocumentsDirectory();
    // directory.delete(recursive: true);
    final dir = Directory(directory.path);
    dir.deleteSync(recursive: true);
    // var path = directory.path;
  }

  Widget getBody() {
    if (picPath != null) {
      return Container(child: Image.file(File(picPath!)));
    }
    if (_isCameraInitialized) {
      return AspectRatio(
        aspectRatio: 1 / controller!.value.aspectRatio,
        child: controller!.buildPreview(),
      );
    }
    return Container();
  }

  Widget getButton() {
    if (picPath == null) {
      return ElevatedButton(
        onPressed: () async {
          XFile? rawImage = await takePicture();
          File imageFile = File(rawImage!.path);

          int currentUnix = DateTime.now().millisecondsSinceEpoch;
          final directory = await getApplicationDocumentsDirectory();
          String fileFormat = imageFile.path.split('.').last;

          await imageFile.copy(
            '${directory.path}/$currentUnix.$fileFormat',
          );
          getPic();
        },
        child: Row(
          children: [
            Text(
              EmojiParser().get('camera').code,
              style: SubHeading.SH26,
            ),
            const SizedBox(width: 8),
            Text(
              'Take Pic',
              style: SubHeading.SH18,
            )
          ],
        ),
      );
    } else {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                picPath = null;
              });
              clearPics();
            },
            child: Row(
              children: [
                Text(
                  EmojiParser().get('arrows_counterclockwise').code,
                  style: SubHeading.SH26,
                ),
                const SizedBox(width: 8),
                Text(
                  'Retake',
                  style: SubHeading.SH18,
                )
              ],
            ),
          ),
          const SizedBox(width: 50),
          ElevatedButton(
            onPressed: () {
              widget.getFinalPic(picPath!);
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Text(
                  EmojiParser().get('white_check_mark').code,
                  style: SubHeading.SH26,
                ),
                const SizedBox(width: 8),
                Text(
                  'Looks good',
                  style: SubHeading.SH18,
                )
              ],
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('path state $picPath');
    return CommonScaffold(
      title: EmojiParser().get('camera').code,
      padding: const EdgeInsets.all(0),
      body: getBody(),
      bottomBar: SingleButtonBottomBar(child: getButton()),
    );
  }
}
