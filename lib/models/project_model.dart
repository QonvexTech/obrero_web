import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProjectModel extends ChangeNotifier {
  int? id;
  int? areaSize;
  int? customerId;
  String? name;
  String? description;
  LatLng? coordinates;
  List? warnings;
  DateTime? startDate;
  DateTime? endDate;
  List<int>? assignee;

  bool isSelected = false; //for table purposes

  ProjectModel(
      {this.id,
      this.areaSize,
      this.assignee,
      required this.customerId,
      required this.name,
      this.description,
      required this.coordinates,
      this.warnings,
      required this.startDate,
      required this.endDate});

  LatLng convertedCoord(String value) {
    return LatLng(
        double.parse(value.split(",")[0]), double.parse(value.split(",")[1]));
  }

  ProjectModel.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.areaSize = json["area_size"];
    this.name = json["name"];
    this.customerId = json["customer_id"];
    this.coordinates = convertedCoord(json["coordinates"]);
    this.description = json["description"];
    this.startDate =
        json["start_date"] != null ? DateTime.parse(json["start_date"]) : null;
    this.endDate =
        json["end_date"] != null ? DateTime.parse(json["end_date"]) : null;
    this.warnings = json["warnings"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["area_size"] = this.areaSize.toString();
    data["name"] = this.name;
    data["customer_id"] = this.customerId.toString();
    data["coordinates"] = (this.coordinates!.latitude.toString() +
        "," +
        this.coordinates!.longitude.toString());

    data["description"] = this.description;
    data["start_date"] = this.startDate!.toString();
    data["end_date"] = this.endDate!.toString();
    data["assignee_id"] =
        this.assignee.toString().replaceAll("[", "").replaceAll("]", "");
    return data;
  }
}
