import 'package:flutter/material.dart';

class EmployeesModel extends ChangeNotifier {
  int? id;
  String? fname;
  String? lname;
  String? email;
  String? picture;
  String? password;
  String? contactNumber;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? enableNotification;
  List? status;
  List? archivedStatus;
  bool isSelected = false;

  EmployeesModel({
    this.id,
    this.picture,
    this.createdAt,
    this.updatedAt,
    this.enableNotification,
    this.status,
    this.archivedStatus,
    required this.fname,
    required this.lname,
    required this.email,
    required this.password,
    required this.contactNumber,
    required this.address,
  });

  EmployeesModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.fname = json["first_name"];
    this.lname = json["last_name"];
    this.email = json["email"];
    this.picture = json["picture"];
    this.contactNumber = json["contact_number"];
    this.address = json["address"];
    this.createdAt =
        json["created_at"] != null ? DateTime.parse(json["created_at"]) : null;
    this.updatedAt =
        json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : null;
    this.enableNotification = json["enable_notification"] == 1 ? true : false;
    this.status = json["status"];
    this.archivedStatus = json["archived_status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id.toString();
    data["first_name"] = this.fname;
    data["last_name"] = this.lname;
    data["email"] = this.email;
    // data["password"] = this.password;
    data["address"] = this.address;
    data["contact_number"] = this.contactNumber;
    // data["prject_id"] = this.id.toString();
    return data;
  }
}