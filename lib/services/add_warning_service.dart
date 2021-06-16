import 'dart:convert';
import 'dart:io';
import 'package:uitemplate/config/global.dart';
import 'package:http/http.dart' as http;

class AddWarning {
  Future addWaring(
      String projectId, String title, String descp, String type) async {
    try {
      var url = Uri.parse(add_warning);
      await http.post(url, body: {
        "user_id"
            "1"
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
          print(data);
          print("Success add");
        } else {
          print("fail api to add warning");
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
