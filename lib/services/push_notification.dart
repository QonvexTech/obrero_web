import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';

class PushNotification extends ChangeNotifier {
  List<RemoteMessage> _notifications = [];
  final String serverToken =
      "AAAA-hFmhDQ:APA91bH1_ygbm_F46KflszWDkQCaY2MwVSltQw4itwkjBQoiOSnSam4BkhTiH5fBcV9sBjd52-d8bxc_00RO48_iaWZYsw20b7tilcKqIqDkIh-J_xv1y8TBxtoDAMlkroj7EcM8ayqO";
  get notifications => _notifications;

  void addNote(value) {
    _notifications.add(value);
    notifyListeners();
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> get fcmToken async => await _firebaseMessaging.getToken();

  Future<void> subscribe(String subscription) async {
    await _firebaseMessaging.subscribeToTopic("$subscription}").then(print);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  void listen() {
    // while open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      print(notification!.title);
      print(message.data);
    });
    // on open
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("MESSAGE OPENED :${event.notification!.title}");
    });

    //background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print("HAS LISTENED");
  }

  Future<void> initialize() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print("Notification Settings : ${settings.announcement}");
    this.listen();
  }

  init() async {
    await Firebase.initializeApp();
    print("Token : ${await fcmToken}");

    this.initialize();
  }

  Future sendNotification(
      ownerFcmToken, Map<String, dynamic>? notifBody) async {
    print(ownerFcmToken);
    print("Sending....");
    var url = Uri.parse("$message_send_api");
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'ADMIN',
            'title': 'Purchasing your product'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'purchasing': true
          },
          'registration_ids': ownerFcmToken,
        },
      ),
    );
  }
}
