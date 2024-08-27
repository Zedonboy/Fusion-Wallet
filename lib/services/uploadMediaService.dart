import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart' as Getx;
// import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'dart:io';

import '../controllers/appController.dart';
import 'dataService/dataService.dart';
import 'dart:async';

class UploadMediaService {
  static Stopwatch sw = Stopwatch();
  final appController = Getx.Get.find<AppController>();

  Future<String> uploadMediaFile(
      BuildContext context, String folderName, File? file, String type) async {
    var path = file!.path;
    // if (file.path.contains("heic") || file.path.contains("HEIC") || file.path.contains("heif") || file.path.contains("HEIF")) {
    //   path = (await HeicToJpg.convert(file.path))!;
    //   file = File(path);
    // }
    if (type == 'image' || type == "Image") {
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: file.path);
      file = rotatedImage;
    }
    return callUploadMedia(context, folderName, file);
  }

  Future<String> callUploadMedia(
      BuildContext context, String folderName, File file) async {
    Response response = await DataService()
        .uploadImage('media-upload/mediaFiles/$folderName', file);
    String res = response.data['url'];
    return res;
  }
}
