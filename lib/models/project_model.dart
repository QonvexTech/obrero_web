import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/project_image_model.dart';
import 'package:uitemplate/models/warning.dart';

class ProjectModel extends ChangeNotifier {
  int? id;
  int? areaSize;
  int? customerId;
  int? status;
  CustomerModel? owner;
  String? name;
  String? description;
  LatLng? coordinates;
  List<WarningModel>? warnings;
  DateTime? startDate;
  DateTime? endDate;
  List<int>? assigneeIds;
  List<EmployeesModel>? assignees;
  String? picture;
  List<ProjectImageModel>? images;
  bool isSelected = false;

  ProjectModel(
      {this.id,
      this.picture,
      this.areaSize,
      this.status,
      this.assigneeIds,
      this.assignees,
      this.owner,
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
    this.status = json["status"];
    this.owner =
        json["owner"] != null ? CustomerModel.fromJson(json["owner"]) : null;
    this.coordinates = convertedCoord(json["coordinates"]);
    this.description = json["description"];
    this.startDate =
        json["start_date"] != null ? DateTime.parse(json["start_date"]) : null;
    this.endDate =
        json["end_date"] != null ? DateTime.parse(json["end_date"]) : null;
    this.warnings = json["warnings"] != null
        ? WarningModel.fromJsonListToWarningsModel(json["warnings"])
        : [];
    this.assignees = json["assignee"] != null
        ? EmployeesModel.fromJsonListToUsersInProject(json["assignee"])
        : [];
    this.images = json["images"] != null
        ? ProjectImageModel.formListtoImageModel(json["images"])
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
