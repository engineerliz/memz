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
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  bool showPic = false;
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
    // clearPics();
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

  List<File> allFileList = [];

  // refreshAlreadyCapturedImages() async {
  //   // Get the directory
  //   final directory = await getApplicationDocumentsDirectory();
  //   List<FileSystemEntity> fileList = await directory.list().toList();
  //   allFileList.clear();

  //   List<Map<int, dynamic>> fileNames = [];

  //   // Searching for all the image and video files using
  //   // their default format, and storing them
  //   fileList.forEach((file) {
  //     if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
  //       allFileList.add(File(file.path));

  //       String name = file.path.split('/').last.split('.').first;
  //       fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
  //     }
  //   });

  //   // Retrieving the recent file
  //   if (fileNames.isNotEmpty) {
  //     final recentFile =
  //         fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
  //     String recentFileName = recentFile[1];
  //     // Checking whether it is an image or a video file
  //     if (recentFileName.contains('.mp4')) {
  //       _videoFile = File('${directory.path}/$recentFileName');
  //       _startVideoPlayer();
  //     } else {
  //       _imageFile = File('${directory.path}/$recentFileName');
  //     }

  //     setState(() {});
  //   }
  // }

  getPic() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    if (fileList.isNotEmpty) {
      setState(() {
        showPic = true;
        picPath = fileList.last.path;
      });
    }
    print('fileList ${fileList.length}');
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

  @override
  Widget build(BuildContext context) {
    print('path state $picPath');
    return CommonScaffold(
      title: EmojiParser().get('camera').code,
      padding: const EdgeInsets.all(0),
      body: getBody(),
      // body: _isCameraInitialized
      //     ? AspectRatio(
      //         aspectRatio: 1 / controller!.value.aspectRatio,
      //         child: controller!.buildPreview(),
      //       )
      //     : Container(),
      bottomBar: SingleButtonBottomBar(
          child: ElevatedButton(
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
      )),
    );
  }
}
