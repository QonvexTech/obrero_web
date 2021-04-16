import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/screens/dashboard/project/project_list.dart';
import 'package:uitemplate/services/autentication.dart';

class ProjectProvider extends ChangeNotifier {
  Widget activePageScreen = ProjectList();
  List<ProjectModel> _projects = [];
  double _latitude = 40.7143528;
  double _longitude = -74.0059731;

  int _perPage = 3;
  int _page = 1;

  bool _isNext = false;
  bool _isPrev = false;

  get isNext => _isNext;
  get isPrev => _isPrev;

  void setPage(Widget page) {
    activePageScreen = page;
    notifyListeners();
  }

  void nextPage() {
    _page += 1;
    _isNext = false;
    fetchProjects();
  }

  void prevPage() {
    _page -= 1;
    _isPrev = false;
    fetchProjects();
  }

  get projects => _projects;
  get latitude => _latitude;
  get longitude => _longitude;
  get page => _page;

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
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body)["data"];
        if (json.decode(response.body)["next_page_url"] != null) {
          _isNext = true;
          notifyListeners();
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _isPrev = true;
          notifyListeners();
        }
        fromJsonListToProject(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future createProjects({required ProjectModel newProject}) async {
    var url = Uri.parse("$project_create_api");
    try {
      var response = await http.post(url, body: newProject.toJson(), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchProjects();
      } else {
        print(response.body);
        print("fail to add");
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateProject({required ProjectModel? newProject}) async {
    var url = Uri.parse("$project_update_api/${newProject!.id}");

    try {
      await http.put(url, body: newProject.toJson(), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);

        notifyListeners();

        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future removeProject({required int id}) async {
    var url = Uri.parse("$project_delete_api/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        _projects.removeWhere((element) => element.id == id);
        notifyListeners();
        if (_projects.length == 0) {
          if (isPrev) {
            prevPage();
          }
        }
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }
}
