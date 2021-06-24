import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';

class History {
  Future removeNotification({required int id}) async {
    var url = Uri.parse("$delete_notification/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
        print("delete success");
      });
    } catch (e) {
      print(e);
      print("delete fails");
    }
  }
}
