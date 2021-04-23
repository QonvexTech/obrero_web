import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/firebase_message.dart';

import '../config/global.dart';
import '../models/employes_model.dart';

class MessageService extends ChangeNotifier {
  List<EmployeesModel> _usersToMessage = [];
  TextEditingController messageController = TextEditingController();

  List<EmployeesModel> get userToMessage => _usersToMessage;

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
      if (message != null) {
        body['message'] = message;
        mess = message;
      }
      if (base64File != null) {
        body['file'] = base64File;
        mess = "Sent an attachment";
      }
      print(ids);

      var url = Uri.parse(message_send_api);
      await http.post(url, body: body, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) async {
        var data = json.decode(response.body);
        print(data);
        if (data['data'] is List) {
          for (var item in data['data']) {
            Map<String, dynamic> nBody = Map<String, dynamic>();
            if (item['receiver_notify'] == 1) {
              nBody = {"title": "Admin", "body": mess};
            }
            await FireBase().sendNotification(item['fcm_tokens'], nBody, item);
          }
        } else {
          Map<String, dynamic> nBody = Map<String, dynamic>();
          if (data['data']['receiver_notify'] == 1) {
            nBody = {"title": "Admin", "body": mess};
          }
          await FireBase().sendNotification(
              data['data']['fcm_tokens'], nBody, data['data']);
        }
      });
    } catch (e) {}
  }
}
