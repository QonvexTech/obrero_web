import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/payment_model.dart';
import 'package:http/http.dart' as http;

class PaymentService extends ChangeNotifier {
  //di ak sure kun fetch as list or for crud la
  final List<PaymentModel> _payments = [];
  get payments => _payments;

  Future createPayment(PaymentModel newPayment) async {
    var url = Uri.parse("$customer_create_api_payment");
    try {
      await http.post(url, body: newPayment.toJson()).then((response) {
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }
}
