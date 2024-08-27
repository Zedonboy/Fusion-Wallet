import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';

class ImagePickerActionSheet {
  Function? onCompletion;

  ImagePickerActionSheet({this.onCompletion});

  File? _image;
  final picker = ImagePicker();

  showImagePickerActionSheet(context) {
    showModalBottomSheet(
      backgroundColor: cardColor.value,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text.rich(
                        TextSpan(
                          text: 'Select',
                          style: TextStyle(
                              color: inputFieldTextColor.value,
                              fontSize: 16,
                              fontFamily: 'sfpro'),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(Icons.close),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new ListTile(
                        leading: SvgPicture.asset(
                          'assets/svgs/image.svg',
                          width: 24,
                          height: 38,
                          color: headingColor.value,
                        ),
                        title: new Text(
                          'Gallery',
                          style: TextStyle(
                              fontFamily: 'sfpro',
                              color: inputFieldTextColor.value,
                              fontSize: 18.0),
                        ),
                        onTap: () {
                          imgFromGallery(context);
                          Navigator.of(context).pop();
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new ListTile(
                      leading: SvgPicture.asset(
                        'assets/svgs/camera.svg',
                        width: 24,
                        height: 24,
                        color: headingColor.value,
                      ),
                      title: new Text(
                        "Camera",
                        style: TextStyle(
                          color: inputFieldTextColor.value,
                          fontSize: 18.0,
                          fontFamily: 'sfpro',
                        ),
                      ),
                      onTap: () {
                        imgFromCamera(context);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> checkCameraPermissions(BuildContext context) async {
    if (Platform.isIOS) {
      await Permission.camera.request();
      await Permission.storage.request();
      await Permission.photos.request();
      //await Permission.microphone.request();
      if (await Permission.camera.isGranted &&
          await Permission.storage.isGranted &&
          (await Permission.photos.isGranted ||
              await Permission.photos.isLimited)) {}
      if (await Permission.camera.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied ||
          await Permission.photos.isPermanentlyDenied ||
          await Permission.storage.isDenied ||
          await Permission.camera.isDenied ||
          await Permission.photos.isDenied) {
        showGeneralDialog(
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text("Gallery",
                      style: TextStyle(
                        fontFamily: 'sfpro',
                      )),
                  content: Text(
                      "Please provide camera and storage permission to continue",
                      style: TextStyle(
                        fontFamily: 'sfpro',
                      )),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cancel",
                          style: TextStyle(
                            fontFamily: 'sfpro',
                          )),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text("Open",
                          style: TextStyle(
                            fontFamily: 'sfpro',
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                        openAppSettings();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return Text('data');
          },
        );
      } else if (await showLimitedPhotosPermissionDialogue(context)) {
      } else {
        await Permission.camera.request();
        await Permission.storage.request();
      }
    }

    if (Platform.isAndroid) {
      await Permission.camera.request();
      await Permission.storage.request();
      if (await Permission.camera.isGranted &&
          await Permission.storage.isGranted) {
      } else if (await Permission.camera.isDenied ||
          await Permission.photos.isDenied ||
          await Permission.storage.isDenied ||
          await Permission.camera.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied ||
          await Permission.photos.isPermanentlyDenied) {
        showGeneralDialog(
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text("Gallery",
                      style: TextStyle(
                        fontFamily: 'sfpro',
                      )),
                  content: Text(
                    "Please provide camera and storage permission to continue",
                    style: TextStyle(
                      fontFamily: 'sfpro',
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'sfpro',
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text(
                        "Open",
                        style: TextStyle(
                          fontFamily: 'sfpro',
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        openAppSettings();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {
            return Text('data');
          },
        );
      }
    }

    if (Platform.isAndroid) {
      return await Permission.camera.isGranted &&
          await Permission.storage.isGranted;
    } else {
      return await Permission.camera.isGranted &&
          await Permission.storage.isGranted &&
          await Permission.photos.isGranted;
    }
  }

  Future<bool> showLimitedPhotosPermissionDialogue(BuildContext context) async {
    if (Platform.isIOS) {
      await Permission.photos.request();
    }
    if (Platform.isIOS && await Permission.photos.isLimited) {
      showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  'Limited Access',
                  style: TextStyle(
                    fontFamily: 'sfpro',
                  ),
                ),
                content: Text(
                  'Please allow full access to media files',
                  style: TextStyle(
                    fontFamily: 'sfpro',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: 'sfpro',
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: Text(
                      "Open",
                      style: TextStyle(
                        fontFamily: 'sfpro',
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      openAppSettings();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Text('data');
        },
      );
    }
    return await Permission.photos.isGranted;
  }

  Future imgFromCamera(BuildContext context) async {
    if (await checkCameraPermissions(context)) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File rotatedImage =
            await FlutterExifRotation.rotateImage(path: pickedFile.path);
        _image = rotatedImage;

        this.onCompletion!(_image);

        // _image = File(pickedFile.path);
      } else {
        this.onCompletion!('No file selected.');
      }
    }
  }

  Future imgFromGallery(context) async {
    if (await checkCameraPermissions(context)) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      // final pickedFile = await ImagePicker().pickMultiImage();
      if (pickedFile != null) {
        File rotatedImage =
            await FlutterExifRotation.rotateImage(path: pickedFile.path);
        _image = rotatedImage;

        this.onCompletion!(_image);
      } else {
        this.onCompletion!('No file selected.');
      }
    }
  }
}
