import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/screens/dashboard/project/project_list.dart';
import 'package:uitemplate/screens/dashboard/project/project_screen.dart';

class ProjectProvider extends ChangeNotifier {
  Widget projectScreen = ProjectList();

  List<ProjectModel> _projects = [];
  double _latitude = 40.7143528;
  double _longitude = -74.0059731;

  int _perPage = 3;
  int _page = 1;

  get projects => _projects;
  get latitude => _latitude;
  get longitude => _longitude;
  get page => _page;

  setProjectScreen(Widget screen) {
    projectScreen = screen;
    notifyListeners();
  }

  set latitude(value) {
    _latitude = value;
    notifyListeners();
  }

  set longitude(value) {
    _longitude = value;
    notifyListeners();
  }

  set page(value) {
    _page = value;
    fetchProjects();
  }

  fromJsonListToProject(List projects) {
    List<ProjectModel> newProjects = [];

    for (var project in projects) {
      newProjects.add(ProjectModel.fromJson(project));
    }

    _projects = newProjects;
    notifyListeners();
  }

  Future fetchProjects() async {
    var url = Uri.parse("$project_api$_perPage?page=$page");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body)["data"];
        fromJsonListToProject(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future createProjects(ProjectModel newProject) async {
    var url = Uri.parse("$project_create_api");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.post(url, body: newProject.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("successfullt added");
      } else {
        print(response.body);
        print("fail to add");
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateProject(
      {required ProjectModel? newProject,
      required ProjectModel? oldProject}) async {
    var url = Uri.parse("$project_update_api/${oldProject!.id}");

    try {
      await http
          .put(url, headers: {"accept": "application/json"}).then((response) {
        var data = json.decode(response.body);
        oldProject = newProject;
        notifyListeners();
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future removeProject(int id) async {
    var url = Uri.parse("$project_delete_api/$id");
    try {
      await http.delete(url, headers: {"accept": "application/json"}).then(
          (response) {
        _projects.removeWhere((element) => element.id == id);
        notifyListeners();
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  void addProject(ProjectModel project) {
    _projects.add(project);
    notifyListeners();
  }
}
