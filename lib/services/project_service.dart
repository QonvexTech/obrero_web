import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/autentication.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';

class ProjectProvider extends ChangeNotifier {
  Widget activePageScreen = ProjectList();
  List<ProjectModel> _projects = [];
  DateTime dateBase = DateTime.now();

  //TODO: update map

  PaginationService paginationService = PaginationService();
  late PaginationModel _pagination =
      PaginationModel(lastPage: 1, fetch: fetchProjects);

  void setPage(Widget page) {
    activePageScreen = page;
    notifyListeners();
  }

  get pagination => _pagination;
  get projects => _projects;

  fromJsonListToProject(List projects) {
    List<ProjectModel> newProjects = [];

    for (var project in projects) {
      newProjects.add(ProjectModel.fromJson(project));
    }

    _projects = newProjects;
    notifyListeners();
  }

  Future fetchProjects() async {
    var url = Uri.parse(
        "$project_api${_pagination.perPage}?page=${_pagination.page}");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body)["data"];
        if (json.decode(response.body)["next_page_url"] != null) {
          _pagination.isNext = true;
          notifyListeners();
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _pagination.isPrev = true;
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

  // Future fetchProjectsBaseOnDates() async {
  //   var url = Uri.parse("$project_api ${dateBase.toString().split(" ")[0]}");
  //   // final prefs = await SharedPreferences.getInstance();
  //   try {
  //     var response = await http.get(url, headers: {
  //       "Accept": "application/json",
  //       "Authorization": "Bearer ${auth.token}",
  //       "Content-Type": "application/x-www-form-urlencoded"
  //     });
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       List data = json.decode(response.body)["data"];
  //       print(data);
  //       // if (json.decode(response.body)["next_page_url"] != null) {
  //       //   _pagination.isNext = true;
  //       //   notifyListeners();
  //       // }
  //       // if (json.decode(response.body)["prev_page_url"] != null) {
  //       //   _pagination.isPrev = true;
  //       //   notifyListeners();
  //       // }
  //       // fromJsonListToProject(data);
  //     } else {
  //       print("error");
  //       print(response.body);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future createProjects({required ProjectModel newProject}) async {
    var url = Uri.parse("$project_create_api");
    try {
      var response = await http.post(url, body: newProject.toJson(), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("success to add");
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
        "Authorization": "Bearer $authToken",
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
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        _projects.removeWhere((element) => element.id == id);
        notifyListeners();
        if (_projects.length == 0) {
          if (_pagination.isPrev) {
            paginationService.prevPage(_pagination);
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
