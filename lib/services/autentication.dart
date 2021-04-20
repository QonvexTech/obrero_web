import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/push_notification.dart';

import '../config/global.dart';

class Authentication extends ChangeNotifier {
  Admin? _data;
  String? token;

  var error;
  get data => _data;

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> login(String email, String password) async {
    try {
      bool success = false;
      var fcmToken = await PushNotification().fcmToken;
      print("LOGGING IN");
      var url = Uri.parse(login_api);
      var response = await http.post(url,
          body: {'email': email, 'password': password, 'fcm_token': fcmToken});
      if (response.statusCode == 200 || response.statusCode == 201) {
        this._data = Admin.fromJson(json.decode(response.body)["data"]);
        print("login success");
        DataCacher().saveCredentials(email, password);
        token = jsonDecode(response.body)['data']['token'];
        print("This is the TOken $token");
        authToken = jsonDecode(response.body)['data']['token'];
        success = true;
        return success;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

Authentication auth = Authentication();
