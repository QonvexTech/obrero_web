import 'dart:convert';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';

class NotificationServices {
  BehaviorSubject<List> _messages = new BehaviorSubject.seeded([]);
  var _newMessage = BehaviorSubject<bool>.seeded(false);
  Stream<List> get $stream => _messages.stream;
  Stream<bool> get $streamNewMessage => _newMessage.stream;

  List get current => _messages.value!;

  void updateAll(List data) {
    _messages.add(data);
  }

  void append(Map data) {
    this.current.add(data);
    _messages.add(this.current);
    _newMessage.add(true);
  }

  void openMessage() {
    _newMessage.add(false);
  }

  Future<void> fetchOld() async {
    try {
      var url = Uri.parse('$api/notification/');
      await http.get(url, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((respo) {
        var data = json.decode(respo.body);

        // fromJsonListToNotification(data);

        print("OLDDATA");

        updateAll(data);
      });
    } catch (e) {
      print("ERROR $e");
    }
  }

  // fromJsonListToNotification(List notifications) {
  //   List<NotificationModel> newNotifications = [];

  //   for (var notification in notifications) {
  //     newNotifications.add(NotificationModel.fromJson(notification));
  //   }
  //   print("object");
  //   print(newNotifications.length);

  //   notificationList = newNotifications;
  // }
}

NotificationServices rxNotificationService = NotificationServices();
