import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/admin_model.dart';
import 'package:uitemplate/models/employee_hours_model.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/models/user_project_model.dart';
import 'package:uitemplate/services/firestore_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/employee/employee_list.dart';

class EmployeeSevice extends ChangeNotifier {
  Widget activePageScreen = EmployeeList();
  List<EmployeesModel>? _users;
  List<EmployeesModel>? _tempUsers;
  List<EmployeesModel>? _usersload;
  List<EmployeesModel>? _tempUsersload;
  PaginationService paginationService = PaginationService();
  List<UserProjectModel>? _employeeProjects;
  final FirestoreService _firestoreService = FirestoreService.instance;

  get employeeProjects => _employeeProjects;

  set employeeProjects(value) {
    _employeeProjects = value;
    notifyListeners();
  }

  late PaginationModel _pagination =
      PaginationModel(lastPage: 1, fetch: fetchUsers, perPage: 10);

  late PaginationModel _paginationload =
      PaginationModel(lastPage: 1, fetch: fetchUsers, page: 1);

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
    _pagination.perPage = _users!.length;
    notifyListeners();
  }

  List<ProjectModel> getEmployeeProjects() {
    List<ProjectModel> projects = [];

    for (var project in _employeeProjects!) {
      projects.add(project.userProject!);
    }
    return projects;
  }

  void initLoad() {
    _usersload = [];
    _tempUsersload = [];
    _paginationload.page = 1;
    _paginationload.perPage = 15;
    loadUser();
  }

  void loadMore() {
    if (_paginationload.isNext) {
      _paginationload.page += 1;
      loadUser();
    }
  }

  //IMAGES
  Uint8List? _base64Image;
  get base64Image => _base64Image;
  get base64ImageEncoded => base64.encode(base64Image.toList());
  set base64Image(value) {
    _base64Image = value;
    notifyListeners();
  }

  get userload => _usersload;
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

  getTotalHours(List<EmployeeHourModel> employeeHours) {
    try {
      double hours = 0.00;
      for (EmployeeHourModel hour in employeeHours) {
        List values = hour.recordedTime!.split(":");

        if (values.length >= 4) {
          hours += double.parse(values[0]) * 24; //days
          hours += double.parse(values[1]); // hours
          hours += double.parse(values[2]) * (1 / 60); //minutes
          hours += double.parse(values[3]) * (1 / 3600); //seconds
        } else {
          hours += double.parse(values[0]); // hours
          hours += double.parse(values[1]) * (1 / 60); //minutes
          hours += double.parse(values[2]) * (1 / 3600); //seconds
        }
        return hours.toStringAsFixed(2);
      }
    } catch (e) {
      print("GetHours $e");
    }
  }

  Future workingProjects(int userId) async {
    try {
      var url = Uri.parse("$user_projects$userId");
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body);

        employeeProjects = UserProjectModel.fromListToUserProjectModel(data);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<String> timeOutAllUser() async {
    String value = "";
    try {
      var url = Uri.parse("$api/user/time_out_all");
      var response = await http.put(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        value = "All users are now time-out";
        this
            ._firestoreService
            .collectionReference
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
            documentSnapshot.reference.update({"is_active": false});
          }
        });
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
    return value;
  }

  Future fetchUsers() async {
    print("fetching...");
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
        print("Employees : $data");
        if (json.decode(response.body)["next_page_url"] != null &&
            json.decode(response.body)["total"] != _pagination.perPage) {
          _pagination.isNext = true;
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _pagination.isPrev = true;
        }
        if (json.decode(response.body)["last_page"] != null) {
          _pagination.lastPage = json.decode(response.body)["last_page"];
        }

        print("TOTAL USER : ${_pagination.totalEntries}");
        print(data);

        var listOfUsers = EmployeesModel.fromJsonListToUsers(data);
        _pagination.totalEntries = json.decode(response.body)["total"];

        if (_paginationload.totalEntries <= _paginationload.perPage) {
          _paginationload.perPage = _paginationload.totalEntries;
        }
        _users = listOfUsers;
        _tempUsers = listOfUsers;

        // if (_pagination.page == 1) {
        //   loadLastPage(_pagination.lastPage, _pagination.perPage);
        // }

        // if (_pagination.page == _pagination.lastPage) {
        //   _users!.removeAt(_users!.length - 1);
        // }

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
      var response = await http.post(url, body: newEmployee.toJson(), headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchUsers();
        notifyListeners();
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
    bool updateSuccess = false;
    try {
      await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      }).then((response) {
        var data = json.decode(response.body);
        if (isAdmin) {
          profileData = Admin.fromJsonUpdate(data['data']);
        }
        fetchUsers();
        print(data);
        notifyListeners();
      });
      updateSuccess = true;
      print("UPDATE SUCCESS");
    } catch (e) {
      print("UPDATE ERROR:$e");
    }
    return updateSuccess;
  }

  Future removeUser({required int id}) async {
    var url = Uri.parse("$user_delete/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
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

  Future loadUser() async {
    var url = Uri.parse(
        "$user_api${_paginationload.perPage}?page=${_paginationload.page}");
    try {
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        List data = json.decode(response.body)["data"];
        if (json.decode(response.body)["next_page_url"] != null &&
            json.decode(response.body)["total"] != _pagination.perPage) {
          _paginationload.isNext = true;
        }
        if (json.decode(response.body)["prev_page_url"] != null) {
          _paginationload.isPrev = true;
        }
        if (json.decode(response.body)["last_page"] != null) {
          _paginationload.lastPage = json.decode(response.body)["last_page"];
        }

        print(data);

        var listOfUsers = EmployeesModel.fromJsonListToUsers(data);

        _pagination.totalEntries = json.decode(response.body)["total"];

        if (_paginationload.totalEntries <= _paginationload.perPage) {
          _paginationload.perPage = _paginationload.totalEntries;
        }
        _usersload!.addAll(listOfUsers);
        _tempUsersload!.addAll(listOfUsers);

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

  // Future loadLastPage(perPage, int page) async {
  //   var url = Uri.parse("$user_api$perPage?page=${page + 1}");
  //   try {
  //     var response = await http.get(url, headers: {
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $authToken",
  //       "Content-Type": "application/x-www-form-urlencoded"
  //     });
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       List data = json.decode(response.body)["data"];
  //       var listOfUsers = EmployeesModel.fromJsonListToUsers(data);
  //       _tempUsers!.add(listOfUsers[0]);
  //       notifyListeners();
  //     } else {
  //       print(response.body);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   notifyListeners();
  // }
}
