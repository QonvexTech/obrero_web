import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:http/http.dart' as http;
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

  void removeUser(EmployeesModel user) {
    _usersToMessage.remove(user);
    notifyListeners();
  }

  Future<bool> sendMessage(
      {required String ids, String? message, String? base64File}) async {
    bool successSend = false;
    try {
      Map body = {
        "to": ids,
      };
      String mess = '';
      if (message != null) {
        body.addAll({"message": message});
        mess = message;
      }

      if (base64File != null) {
        body.addAll({"file": "data:image/jpg;base64,$base64File"});
        mess = "Sent an attachment";
      }

      var url = Uri.parse(message_send_api);
      await http.post(url, body: body, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) async {
        var data = json.decode(response.body);

        if (data['data'] is List) {
          for (var item in data['data']) {
            Map<String, dynamic> nBody = Map<String, dynamic>();
            if (item['receiver_notify'] == 1) {
              nBody = {
                "title": "Admin",
                "body": mess.length > 200
                    ? "L'administrateur vous a envoyé un long message. veuillez vérifier votre boîte de réception."
                    : mess
              };
            }
            await FireBase().sendNotification(item['fcm_tokens'], nBody, item);
          }
        } else {
          Map<String, dynamic> nBody = Map<String, dynamic>();
          if (data['data']['receiver_notify'] == 1) {
            nBody = {
              "title": "Admin",
              "body": mess.length > 200
                  ? "L'administrateur vous a envoyé un long message. veuillez vérifier votre boîte de réception."
                  : mess,
            };
          }
          await FireBase().sendNotification(
              data['data']['fcm_tokens'], nBody, data['data']);
        }
        print(data);
      });
      return true;
    } catch (e) {
      return successSend;
    }
  }

  Future showHistory() async {
    try {
      var url = Uri.parse(message_history);
      await http.get(url, headers: {
        "accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        var data = json.decode(response.body);
        print("HISTORY MESSAGES");
        historyMessages = data["data"];
      });
    } catch (e) {
      print(e);
    }
  }
}
