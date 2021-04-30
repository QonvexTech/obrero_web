import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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
}
