import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/push_notification.dart';

class Authentication extends ChangeNotifier {
  Admin? _data;
  static String token = "";
  var error;
  get data => _data;

  getLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();

    _data = Admin.fromJson(
        json.decode(prefs.getString("profile_details")!)["data"]);

    token = _data!.token!;
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> login(String email, String password) async {
    try {
      bool success = false;
      var fcmToken = await PushNotification().fcmToken;

      var url = Uri.parse(login_api);
      var response = await http.post(url,
          body: {'email': email, 'password': password, 'fcm_token': fcmToken});
      if (response.statusCode == 200 || response.statusCode == 201) {
        this._data = Admin.fromJson(json.decode(response.body)["data"]);
        print("login success");
        cacher.saveCredentials(email, password);
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
