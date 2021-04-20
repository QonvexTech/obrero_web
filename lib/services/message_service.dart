import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/push_notification.dart';

class MessageService extends ChangeNotifier {
  List<EmployeesModel> _usersToMessage = [];
  TextEditingController messageController = TextEditingController();

  get userToMessage => _usersToMessage;

  void messageUpdate() {
    notifyListeners();
  }

  void addUserToMessage(EmployeesModel user) {
    _usersToMessage.add(user);
    notifyListeners();
  }

  Future<void> sendMessage(
      {required String ids, String? message, String? base64File}) async {
    //ids = 1,2,3
    //

    try {
      Map body = {
        "to": ids,
      };
      String mess = '';
      // if (message != null) {
      //   body['message'] = message;
      //   mess = message;
      // }
      // if (base64File != null) {
      //   body['file'] = base64File;
      //   mess = "Sent an attachment";
      // }
      print(ids);
      print(auth.token);
      PushNotification notification = new PushNotification();
      var url = Uri.parse(message_send_api);
      await http.post(url, body: body, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
        if (data['data'] is List) {
          for (var item in data['data']) {
            Map<String, dynamic> nBody = Map<String, dynamic>();
            if (item['receiver_notify'] == 1) {
              nBody = {"title": "Admin", "body": mess};
            }
            notification.sendNotification(item['fcm_tokens'], nBody);
          }
        } else {
          Map<String, dynamic> nBody = Map<String, dynamic>();
          if (data['data']['receiver_notify'] == 1) {
            nBody = {"title": "Admin", "body": mess};
          }
          notification.sendNotification(data['data']['fcm_tokens'], nBody);
        }
      });
    } catch (e) {}
  }
}
