import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/view_model/logs/log_api_call.dart';
import '../config/global.dart';

class Authentication {
  var error;
  Future<bool> login(String email, String password) async {
    try {
      bool success = false;
      print("LOGGING IN");
      var url = Uri.parse(login_api);
      var response = await http.post(url, body: {
        'email': email,
        'password': password
      }, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        profileData = Admin.fromJson(json.decode(response.body)["data"]);
        print("login success");
        print(profileData);
        DataCacher().saveCredentials(email, password);

        authToken = jsonDecode(response.body)['data']['token'];
        print("This is the TOken $authToken");

        await logApiCall.fetchServer();

        success = true;
        return success;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addToken() async {
    try {
      bool success = false;
      String? fcmToken;
      try {
        fcmToken = await FireBase().fcmToken;
      } catch (e) {
        print(e);
      }
      var url = Uri.parse(add_token);
      var response = await http.post(url, body: {
        "token": fcmToken
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(json.decode(response.body));
        success = true;
        return success;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}

Authentication auth = Authentication();
