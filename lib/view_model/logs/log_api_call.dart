import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/date_sorter.dart';
import 'package:uitemplate/services/log_service.dart';

class LogApiCall {
  LogApiCall._privateConstructor();
  static final LogApiCall _instance = LogApiCall._privateConstructor();
  static LogApiCall get instance => _instance;
  static String url = "https://obrero.checkmy.dev/api/notification";

  Future<void> fetchServer() async {
    try {
      await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      }).then((response) {
        List data = DateSorter.sort(data: json.decode(response.body));
        List<LogModel> logs = [];
        for (var item in data) {
          logs.add(LogModel.fromJson(item));
        }
        logService.populate(data: logs);
      });
    } catch (e) {
      print(e.toString());
    }
  }
}

LogApiCall logApiCall = LogApiCall.instance;
