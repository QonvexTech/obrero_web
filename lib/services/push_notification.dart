import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PushNotification extends ChangeNotifier {
  List<RemoteMessage> _notifications = [];
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

  Future<void> listen() async {
    // while open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      print(notification!.title);
      print(message.data);
    }).onData((message) {
      addNote(message);
    });
    // on open
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("MESSAGE OPENED :${event.notification!.title}");
    });

    //background
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
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
