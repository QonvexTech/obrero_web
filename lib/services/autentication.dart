import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/services/caching.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/services/notification_services.dart';
import '../config/global.dart';

class Authentication {
  var error;

  Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> login(String email, String password) async {
    try {
      bool success = false;
      var fcmToken = await FireBase().fcmToken;
      print("LOGGING IN");
      var url = Uri.parse(login_api);
      var response = await http.post(url,
          body: {'email': email, 'password': password, 'fcm_token': fcmToken});
      if (response.statusCode == 200 || response.statusCode == 201) {
        profileData = Admin.fromJson(json.decode(response.body)["data"]);
        print("login success");
        DataCacher().saveCredentials(email, password);

        authToken = jsonDecode(response.body)['data']['token'];
        print("This is the TOken $authToken");
        rxNotificationService.fetchOld();
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
