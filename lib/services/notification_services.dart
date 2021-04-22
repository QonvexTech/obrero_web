import 'dart:convert';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';

class NotificationServices {
  BehaviorSubject<List> _messages = new BehaviorSubject.seeded([]);
  Stream<List> get $stream => _messages.stream;
  List get current => _messages.value!;

  void updateAll(List data) {
    _messages.add(data);
  }

  void append(Map data) {
    this.current.add(data);
    _messages.add(this.current);
  }

  Future<void> fetchOld() async {
    try {
      var url = Uri.parse('$api/notification/');
      await http.get(url, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((respo) {
        var data = json.decode(respo.body);
        print(data);
        updateAll(data);
      });
    } catch (e) {
      print("ERROR $e");
    }
  }
}

NotificationServices rxNotificationService = NotificationServices();
