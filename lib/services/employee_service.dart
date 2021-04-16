import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/screens/dashboard/employee/employee_list.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/autentication.dart';

class EmployeeSevice extends ChangeNotifier {
  Widget activePageScreen = EmployeeList();
  List<EmployeesModel>? _users;
  int _perPage = 10;
  int _page = 1;
  int? _lastPage;

  bool _isNext = false;
  bool _isPrev = false;

  get isNext => _isNext;
  get isPrev => _isPrev;
  get lastPage => _lastPage;
  get page => _page;

  void setPageScreen(Widget page) {
    activePageScreen = page;
    notifyListeners();
  }

  void setTablePage(int value) {
    _isNext = false;
    _isPrev = false;
    _page = value;
    fetchUsers();
  }

  void nextPage() {
    _page += 1;
    _isNext = false;
    fetchUsers();
  }

  void prevPage() {
    _page -= 1;
    _isPrev = false;
    fetchUsers();
  }

  setActivePageScreen(Widget newPage) {
    activePageScreen = newPage;
    notifyListeners();
  }

  get users => _users;

  fromJsonListToUsers(List users) {
    List<EmployeesModel> newUsers = [];
    for (var user in users) {
      newUsers.add(EmployeesModel.fromJson(user));
    }
    _users = newUsers;
    notifyListeners();
  }

  Future fetchUsers() async {
    var url = Uri.parse("$user_api$_perPage?page=$_page");
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
        if (json.decode(response.body)["last_page"] != null) {
          _lastPage = json.decode(response.body)["last_page"];

          notifyListeners();
        }
        fromJsonListToUsers(data);
        // print(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future createUser(EmployeesModel newEmployee) async {
    var url = Uri.parse("$user_register");
    try {
      var response = await http.post(url, body: {
        newEmployee.toJson()
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
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

  Future updateUser({required Map<String, dynamic> body}) async {
    var url = Uri.parse("$user_update");
    try {
      await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + Authentication.token,
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

  //TODO:fix delete user

  Future removeUser({required int id}) async {
    var url = Uri.parse("$user_delete/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${Authentication.token}",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
        _users!.removeWhere((element) => element.id == id);
        notifyListeners();
        if (_users!.length == 0) {
          if (isPrev) {
            prevPage();
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
