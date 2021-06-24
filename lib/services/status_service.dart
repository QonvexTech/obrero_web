import 'dart:convert';
import 'package:uitemplate/config/global.dart';
import 'package:http/http.dart' as http;

class StatusName {
  Future renameStatus(String colorId, String title) async {
    try {
      var url = Uri.parse(update_color_name);
      return await http.put(url,
          body: {"id": colorId.toString(), "name": title}).then((value) {
        var data = json.decode(value.body);

        print("UPDATE COLOR: $data");
        if (value.statusCode == 200) {
          print("success edit");
          return true;
        } else {
          print("fail edit");
          return false;
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
