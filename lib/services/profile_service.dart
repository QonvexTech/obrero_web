import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';

class ProfileService extends ChangeNotifier {
  Admin? admin;
  bool _isLoading = false;
  File? _file;
  Uint8List? _base64Image;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  get file => _file;

  get base64Image => _base64Image;
  get base64ImageEncoded => base64.encode(_base64Image!.toList());
  set base64Image(value) {
    _base64Image = value;
    notifyListeners();
  }

  Future<bool> changePassword(String id, String newPassword) async {
    var url = Uri.parse("$change_password_api");
    bool success = false;
    try {
      var response = await http.put(url, body: {
        "id": id,
        "new_password": newPassword
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        success = true;
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    return success;
  }
}
