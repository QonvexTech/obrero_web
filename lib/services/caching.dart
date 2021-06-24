import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/services/autentication.dart';

class DataCacher {
  Future saveCredentials(String email, String password) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('email', email);
    _prefs.setString('password', password);
  }

  Future getCredentials(context) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var email = _prefs.getString('email');
      var password = _prefs.getString('password');

      if (email != null && password != null) {
        await Authentication().login(email, password).then((value) {
          if (value) {
            Navigator.pushReplacementNamed(context, "/home");
          } else {
            Navigator.pushReplacementNamed(context, "/login");
          }
        });
        return;
      }
      //navigate to login page
      Navigator.pushReplacementNamed(context, '/login');
      return;
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future removeCredentials(context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('email');
    _prefs.remove('password');
    Navigator.pushReplacementNamed(context, "/login");
  }
}
