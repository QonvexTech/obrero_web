import 'package:uitemplate/models/employee_hours_model.dart';
import 'package:uitemplate/models/project_model.dart';

class UserProjectModel {
  int? id;
  int? projectId;
  ProjectModel? userProject;
  List<EmployeeHourModel>? employeeHourList;

  UserProjectModel(this.id, this.userProject, this.employeeHourList);
  UserProjectModel.fromJson(Map json) {
    this.id = json["id"];
    this.projectId = json["project_id"];
    this.userProject = json["project_details"] != null
        ? ProjectModel.fromJson(json["project_details"])
        : null;
    this.employeeHourList = json["project_details"]["employee_hours"] != null
        ? fromListemployeeHours(json["project_details"]["employee_hours"])
        : null;
  }

  static List<UserProjectModel> fromListToUserProjectModel(List userProjects) {
    List<UserProjectModel> newUserProjects = [];

    for (var project in userProjects) {
      print(project);
      print("");
      newUserProjects.add(UserProjectModel.fromJson(project));
    }
    print("userproject Length : ${newUserProjects.length}");
    return newUserProjects;
  }

  static List<EmployeeHourModel> fromListemployeeHours(List emlpoyeeHours) {
    List<EmployeeHourModel> newEmployeeHours = [];

    for (var hours in emlpoyeeHours) {
      newEmployeeHours.add(EmployeeHourModel.fromJson(hours));
    }

    return newEmployeeHours;
  }
}
