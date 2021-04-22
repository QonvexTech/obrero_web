import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotification extends ChangeNotifier {
  RemoteNotification? _notifications;

  get getNotification => _notifications;
  set setNotification(value) {
    print("been set");
    _notifications = value;
    notifyListeners();
  }
  // void addText() {
  //   _notifications.add("notification");
  //   notifyListeners();
  // }
}
