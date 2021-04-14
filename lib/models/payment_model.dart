import 'package:flutter/material.dart';

class PaymentModel extends ChangeNotifier {
  int? id;
  int? customerId;
  int? status;
  double? amount;

  PaymentModel({
    this.id,
    this.customerId,
    this.status,
    this.amount,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.customerId = json["customer_id"];
    this.amount = json["amount"];
    this.status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["customer_id"] = this.customerId;
    data["amount"] = this.amount;
    data["status"] = this.status;
    return data;
  }
}
