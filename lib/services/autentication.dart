import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/services/push_notification.dart';

class Authentication extends ChangeNotifier {
  Admin _data =
      Admin(id: 1, firstName: "super", lastName: "admin", email: "@gmail");
  var error;
  get data => _data;

  getLocalProfile() async {
    print("Local");
    final prefs = await SharedPreferences.getInstance();

    _data = Admin.fromJson(
        json.decode(prefs.getString("profile_details")!)["data"]);
    print("empty");
  }

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> login(String email, String password) async {
    bool success = false;
    var fcmToken = await PushNotification().fcmToken;
    print("Token : $fcmToken");
    var url = Uri.parse(login_api);
    final prefs = await SharedPreferences.getInstance();

    try {
      var response = await http.post(url,
          body: {'email': email, 'password': password, 'fcm_token': fcmToken});
      if (response.statusCode == 200 || response.statusCode == 201) {
        this._data = Admin.fromJson(json.decode(response.body)["data"]);
        await prefs.setString("profile_details", response.body);

        print(response.body);
        print("login success");
        success = true;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }

    return success;
  }
}
