import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/payment_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/autentication.dart';

class PaymentService extends ChangeNotifier {
  //TODO: payments crud test
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

  Future removePayments({required int id}) async {
    var url = Uri.parse("$customer_delete_api_payment/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${auth.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future updatePayments({required PaymentModel editPayment}) async {
    var url = Uri.parse("$customer_update_api_payment");
    try {
      await http.put(url, body: editPayment.toJson(), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${auth.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }
}
