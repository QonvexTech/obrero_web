import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/pagination_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:http/http.dart' as http;
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/widgetService/table_pagination_service.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';
import 'package:uitemplate/widgets/mypicker.dart';

class ProjectProvider extends ChangeNotifier {
  Widget activePageScreen = ProjectList(
    assignUser: false,
  );
  List<ProjectModel>? _projects;
  List<ProjectModel>? _projectsDateBase = [];
  List<ProjectModel> _tempProjects = [];
  PaginationService paginationService = PaginationService();
  ProjectModel? _projectOnDetails;
  DatePickerController2 dateController = DatePickerController2();
  DateTime _selectedDate = DateTime.now();
  String hours = "0.00";
  List<String> listHours = [];

  late PaginationModel _pagination =
      PaginationModel(lastPage: 1, fetch: fetchProjects);

  //SEARCH
  TextEditingController searchController = TextEditingController();

  get selectedDate => _selectedDate;

  Future setSelectedDate(value) async {
    _selectedDate = value;
    dateController.jumpToSelection(_selectedDate);
    notifyListeners();
  }

  void nextDate(BuildContext context, MapService mapService) {
    _selectedDate = _selectedDate.add(Duration(days: 5));
    dateController.animateToDate(_selectedDate);
    fetchOnDates(context: context, mapService: mapService);
    notifyListeners();
  }

  void prevDate(BuildContext context, MapService mapService) {
    _selectedDate = _selectedDate.subtract(Duration(days: 5));
    dateController.animateToDate(_selectedDate);
    fetchOnDates(context: context, mapService: mapService);
    notifyListeners();
  }

  Future<DateTime> selectDate(
      {required BuildContext context,
      required MapService mapService,
      required bool isNow,
      required DatePickerController2 controllerDate}) async {
    if (isNow) {
      _selectedDate = DateTime.now();
    } else {
      final DateTime? picked = await showDatePicker(
          locale: Locale('fr', 'CA'),
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(1999),
          lastDate: DateTime(3000));
      if (picked != null && picked != _selectedDate) {
        _selectedDate = picked;
      }
    }
    fetchOnDates(context: context, mapService: mapService);
    notifyListeners();

    return _selectedDate;
  }

  Future fetchOnDates(
      {required BuildContext context, required MapService mapService}) async {
    fetchProjectsBaseOnDates().whenComplete(() {
      mapService.mapInit(_projectsDateBase!, context);
    }).whenComplete(() {
      fetchProjectsBaseOnDates().whenComplete(() {
        notifyListeners();
      });
    });
  }

  init(mapService) {
    fetchProjectsBaseOnDates()
        .then((x) => mapService.mapInit(_projectsDateBase));
    notifyListeners();
  }

  Future initHours(int projectId) async {
    hours = await fetchHours(projectId);
    return hours;
  }

  search(String text) {
    _projects = _tempProjects;
    _projects = _projects!
        .where((element) =>
            element.name!.toLowerCase().contains(text.toLowerCase()) ||
            "${element.coordinates!.latitude}, ${element.coordinates!.longitude}"
                .toLowerCase()
                .contains(text.toLowerCase()))
        .toList();
    if (text.isEmpty) {
      _projects = _tempProjects;
    }
    notifyListeners();
  }
  //-------------

  void setPage({required Widget page}) {
    activePageScreen = page;
    notifyListeners();
  }

  set projectOnDetails(value) {
    _projectOnDetails = value;
    notifyListeners();
  }

  get projectOnDetails => _projectOnDetails;
  get pagination => _pagination;
  get projects => _projects;
  get projectsDateBase => _projectsDateBase;

  addWaring(value) {
    _projectOnDetails!.warnings!.add(value);
    notifyListeners();
  }

  Future<String> fetchHours(int projectId) async {
    String? hours;
    try {
      var url = Uri.parse("$projectTotalHours$projectId");
      var response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);

        hours = double.parse(data['hours'].toString()).toStringAsFixed(2);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return hours!;
  }

  Future fetchProjects() async {
    var url = Uri.parse(
        "$project_api${_pagination.perPage}?page=${_pagination.page}");
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
        ProjectModel.fromJsonListToProject(data).then((value) {
          _projects = value;
          _tempProjects = value;
        });

        notifyListeners();
        print(data);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future fetchProjectsBaseOnDates(
      {DateTime? dateSelected,
      context,
      DatePickerController2? controller}) async {
    if (dateSelected == null) {
      dateSelected = _selectedDate;
      // controller!.animateToDate(selectedDate);
    } else {
      _selectedDate = dateSelected;
      // controller!.animateToDate(dateSelected);
    }
    var url = Uri.parse("$project_api_date");
    // final prefs = await SharedPreferences.getInstance();
    try {
      var response = await http.post(url, body: {
        "date": dateSelected.toString().split(" ")[0]
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        List datas = json.decode(response.body);

        ProjectModel.fromJsonListToProject(datas).then((value) {
          _projectsDateBase = value;
        });
      } else {
        print("fail");
        print(response.body);
      }
    } catch (e) {
      print("project fetch error : $e");
    }
  }

  Future createProjects({required ProjectModel newProject}) async {
    var url = Uri.parse("$project_create_api");
    try {
      var response = await http.post(url, body: newProject.toJson(), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchProjectsBaseOnDates();
        fetchProjects();
        print("success to add");
      } else {
        print(response.body);
        print("fail to add");
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future updateProject({required Map bodyToEdit}) async {
    var url = Uri.parse("$project_update_api");
    try {
      await http.put(url, body: bodyToEdit, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        projectOnDetails = ProjectModel.fromJson(data["data"]);

        print("THIS PROJECT : $data");
        notifyListeners();
        fetchProjects();
        fetchProjectsBaseOnDates();
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
        _projects!.removeWhere((element) => element.id == id);
        projectsDateBase!.removeWhere((element) => element.id == id);
        notifyListeners();
        if (_projects!.length == 0) {
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
