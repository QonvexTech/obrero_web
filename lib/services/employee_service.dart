import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/employee/employee_list.dart';

class EmployeeSevice extends ChangeNotifier {
  Widget activePageScreen = EmployeeList();
  List<EmployeesModel>? _users;
  List<EmployeesModel>? _tempUsers;
  PaginationService paginationService = PaginationService();

  late PaginationModel _pagination =
      PaginationModel(lastPage: 1, fetch: fetchUsers);

  //TODO saerch un finish
  TextEditingController searchController = TextEditingController();
  search(String text) {
    _users = _tempUsers;
    _users = _users!
        .where((element) =>
            "${element.fname!} ${element.lname!}"
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            element.lname!.toLowerCase().contains(text.toLowerCase()) ||
            element.email!.toLowerCase().contains(text.toLowerCase()))
        .toList();
    if (text.isEmpty) {
      _users = _tempUsers;
    }
    notifyListeners();
  }

  get pagination => _pagination;

  void setPageScreen({required Widget page}) {
    activePageScreen = page;
    notifyListeners();
  }

  setActivePageScreen(Widget newPage) {
    activePageScreen = newPage;
    notifyListeners();
  }

  List<EmployeesModel>? get users => this._users;

  List<ProjectModel> usersProjects(id, allProjects) {
    List<ProjectModel> newProjects = [];
    for (ProjectModel project in allProjects) {
      for (EmployeesModel user in project.assignees!) {
        if (user.id == id) {
          newProjects.add(project);
        }
      }
    }
    notifyListeners();
    return newProjects;
  }

  Future fetchUsers() async {
    var url =
        Uri.parse("$user_api${_pagination.perPage}?page=${_pagination.page}");
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
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _pagination.isPrev = true;
        }
        if (json.decode(response.body)["last_page"] != null) {
          _pagination.lastPage = json.decode(response.body)["last_page"];
        }

        _pagination.totalEntries = json.decode(response.body)["total"];
        if (_pagination.totalEntries < _pagination.perPage) {
          _pagination.perPage = _pagination.totalEntries;
        }
        var listOfUsers = EmployeesModel.fromJsonListToUsers(data);
        _users = listOfUsers;
        _tempUsers = listOfUsers;
        searchController.clear();
        print(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future createUser(EmployeesModel newEmployee) async {
    var url = Uri.parse("$user_register");
    try {
      var response = await http.post(url, body: {
        newEmployee.toJson()
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future updateUser(
      {required Map<String, dynamic> body, bool isAdmin = false}) async {
    var url = Uri.parse("$user_update");
    try {
      await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      }).then((response) {
        var data = json.decode(response.body);
        if (isAdmin) {
          profileData = Admin.fromJsonUpdate(data['data']);
          notifyListeners();
        }
        print(data);
      });
    } catch (e) {
      print("UPDATE ERROR:$e");
    }
  }

  //TODO:fix delete user

  Future removeUser({required int id}) async {
    var url = Uri.parse("$user_delete/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        // print(data);
        _users!.removeWhere((element) => element.id == id);

        if (_users!.length == 0) {
          if (_pagination.isPrev) {
            paginationService.prevPage(_pagination);
          }
        }
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }
}
