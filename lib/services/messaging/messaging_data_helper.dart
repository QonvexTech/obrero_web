import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:uitemplate/models/employes_model.dart';

class MessagingDataHelper {
  static bool contains(List<EmployeesModel> list,int needle) {
    for(var item in list) {
      if(item.id == needle){
        return true;
      }
    }
    return false;
  }
  static String base64ImageEncoded(Uint8List byte) => base64.encode(byte.toList());
  static void pickImage(ValueChanged callback) async {
    await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png'
        ]).then((pickedFile) {
      if (pickedFile != null) {
        callback(base64ImageEncoded(pickedFile.files[0].bytes!));
      }
    });
  }
}