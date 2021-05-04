import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/log_service.dart';
import 'package:uitemplate/services/notification_services.dart';

class FireBase extends ChangeNotifier {
  final String serverToken =
      "AAAA-hFmhDQ:APA91bH1_ygbm_F46KflszWDkQCaY2MwVSltQw4itwkjBQoiOSnSam4BkhTiH5fBcV9sBjd52-d8bxc_00RO48_iaWZYsw20b7tilcKqIqDkIh-J_xv1y8TBxtoDAMlkroj7EcM8ayqO";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> get fcmToken async => await _firebaseMessaging.getToken();

  // Future<void> subscribe(String subscription) async {
  //   await _firebaseMessaging.subscribeToTopic("$subscription}").then(print);
  // }

  Future<void> initialize({required context}) async {
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // rxNotificationService
      //     .append(json.decode(message.data['notification_data']));

      if (message.data['notification_data'] != null) {
        // messages.add(message.data['notification_data']);
        logService.append(data: LogModel.fromJson(json.decode(message.data['notification_data'])));
        // print(messages);
      }

      return;
      // print(messages);
    });

    // on open
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("MESSAGE OPENED :${event.notification!.title}");
    });

    //background
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('Handling a background message ${message.messageId}');
    });
  }

  init({required context}) async {
    await Firebase.initializeApp();
    print("Token : ${await fcmToken}");
    this.initialize(context: context);
  }

  Future sendNotification(
      ownerFcmToken, Map<String, dynamic>? notifBody, Map? message) async {
    print(ownerFcmToken);
    print("Sending....");
    var url = Uri.parse(firebase_messaging);
    await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': notifBody,
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'message': message,
            'purchasing': true
          },
          'registration_ids': ownerFcmToken,
        },
      ),
    )
        .then((response) {
      var data = json.decode(response.body);
      print(data);
    });
  }
}
