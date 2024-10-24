import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}


Future<void> requestStoragePermissions() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}


Future<File?> pickAudio() async {
  try {
    final filePickerResult =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (filePickerResult != null) {
      return File(filePickerResult.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePickerResult =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (filePickerResult != null) {
      return File(filePickerResult.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

//  Color to hex and vice versa

String rgbToHex(Color color){
  return "${color.red.toRadixString(16).padLeft(2,'0')}${color.green.toRadixString(16).padLeft(2,'0')}${color.blue.toRadixString(16).padLeft(2,'0')}";
}

Color hexToColor(String hex){
  return Color(int.parse(hex ,radix: 16) + 0xff000000);
}

