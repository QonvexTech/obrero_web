import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/log_service.dart';

class FireBase extends ChangeNotifier {
  final String serverToken =
      "AAAA-hFmhDQ:APA91bEtMWAdXM-GDjI4eYFa3CdVWs33rkqjPRXIaky1lYhrl1fTJXH968jzHEsB20Dn9KUlaCKCTe5C6pUpw--zTDvAJPfeRP3P51FZLagFjOML4QDqSxR-2jGMBaaGK9G_S6SNo1Mo";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<String?> get fcmToken async => await _firebaseMessaging.getToken();
  Future<void> initialize({required context}) async {
    try {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        if (message.data['notification_data'] != null) {
          logService.append(
              data: LogModel.fromJson(
                  json.decode(message.data['notification_data'])));
          print(message.data['notification_data']);
        }

        return;
      });
    } catch (e) {
      print(e);
    }
  }

  init({required context}) async {
    await Firebase.initializeApp();
    print("Token : ${await fcmToken}");
    this.initialize(context: context);
  }

  Future sendNotification(
      ownerFcmToken, Map<String, dynamic>? notifBody, Map? message) async {
    print("Sending....here");
    var url = Uri.parse(firebase_messaging);
    var response = await http.post(
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
    );

    print(response.body);
  }
}
