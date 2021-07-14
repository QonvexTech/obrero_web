import 'dart:convert';
import 'dart:io';
import 'package:uitemplate/config/global.dart';
import 'package:http/http.dart' as http;

class AddWarning {
  Future<dynamic> addWaring(
      String projectId, String title, String descp, String type) async {
    dynamic? warning;
    try {
      var url = Uri.parse(add_warning);
      await http.post(url, body: {
        "user_id": "1",
        "project_id": projectId,
        "title": title,
        "description": descp,
        "type": type
      }, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((value) {
        if (value.statusCode == 200) {
          var data = json.decode(value.body)["data"];
          warning = data;
          print("add warnings");
          return data;
        } else {
          print("fail api to add warning");
        }
      });
    } catch (e) {
      print(e);
    }
    return warning!;
  }

  Future removeWarning(int id) async {
    try {
      var url = Uri.parse("$remove_warning$id");
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((value) {
        if (value.statusCode == 200) {
          var data = json.decode(value.body)["data"];
          print(data);

          print("deleted Successfuly");
        } else {
          print("fail to delete warning");
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
