import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/color_model.dart';

class ColorsService {
  ColorsService._private();
  static final ColorsService _instance = ColorsService._private();
  static ColorsService get instance => _instance;

  Future<List<ColorModels>?> get getColors async {
    try {
      return await http.get(Uri.parse("$api/colors")).then((res) {
        var data = json.decode(res.body);
        print(data);
        print("COLORSTATUS : ${res.statusCode}");
        if (res.statusCode == 200) {
          List colorsData = data['data'];
          List<ColorModels> colorss = [];
          for (var color in colorsData) {
            colorss.add(ColorModels.fromJson(color));
          }

          print("COLORred : ${colorsData.length}");

          return colorss;
        } else {
          return null;
        }
      });
    } catch (e) {
      print("COLOR ERROR $e");
      return null;
    }
  }

  Future<bool> updateColor(
      {required int colorId, required String color}) async {
    try {
      return await http.put(Uri.parse("$api/colors/update_color"),
          body: {"id": colorId.toString(), "color": color}).then((value) {
        var data = json.decode(value.body);

        print("UPDATE COLOR: $data");
        if (value.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      return false;
    }
  }

  getAssetImageBaseOnColors() {}
}

ColorsService colorsService = ColorsService.instance;
