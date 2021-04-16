import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uitemplate/services/autentication.dart';

class DataCacher {
  Future<SharedPreferences> get preference async =>
      await SharedPreferences.getInstance();

  Future saveCredentials(String email, String password) async {
    SharedPreferences _prefs = await this.preference;
    _prefs.setString('email', email);
    _prefs.setString('password', password);
  }

  Future getCredentials(context) async {
    try {
      SharedPreferences _prefs = await this.preference;
      var email = _prefs.getString('email');
      var password = _prefs.getString('password');
      print("YAHOOOO");
      if (email != null && password != null) {
        print(email);
        print(password);
        //call login api
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
}

DataCacher cacher = DataCacher();
