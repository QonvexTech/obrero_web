import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uitemplate/models/employes_model.dart';

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
  List<int>? assigneeIds;
  List<EmployeesModel>? assignees;
  String? picture;
  bool isSelected = false; //for table purposes

  ProjectModel(
      {this.id,
      this.picture,
      this.areaSize,
      this.assigneeIds,
      this.assignees,
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
    this.assignees = json["assignee"] != null
        ? EmployeesModel.fromJsonListToUsersInProject(json["assignee"])
        : [];
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
    data["picture"] = this.picture;
    data["start_date"] = this.startDate!.toString();
    data["end_date"] = this.endDate!.toString();
    data["assignee_ids"] =
        this.assigneeIds.toString().replaceAll("[", "").replaceAll("]", "");
    return data;
  }

  static List<ProjectModel> fromJsonListToProject(List projects) {
    List<ProjectModel> newProjects = [];

    for (var project in projects) {
      newProjects.add(ProjectModel.fromJson(project));
    }
    return newProjects;
  }
}
