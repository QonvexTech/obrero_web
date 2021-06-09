import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:http/http.dart' as http;

class ProjectAddService extends ChangeNotifier {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  double _areaSize = 0.0;

  List<int> _assignIds = [];
  List<int> _assignIdsToRemove = [];
  List<int> _assignIdsToAdd = [];
  int _activeOwnerIndex = 0;
  List<Uint8List>? _projectImages = [];
  Uint8List? _base64Image;
  Map<dynamic, dynamic> _bodyToEdit = {};
  bool justScroll = true;

  get bodyToEdit => _bodyToEdit;
  set bodyToEdit(value) => _bodyToEdit = value;

  get areaSize => _areaSize;
  set areaSize(value) {
    _areaSize = value;
    notifyListeners();
  }

  //assigns api
  get assignIdsToRemove => _assignIdsToRemove;
  get assignIdsToAdd => _assignIdsToAdd;

  initUint8() {
    _projectImages = [];
  }

  addBodyEdit(dynamic value) {
    _bodyToEdit.addAll(value);
    notifyListeners();
  }

  userToAssignIds(List<EmployeesModel> users) {
    List<int> ids = [];
    for (var user in users) {
      ids.add(user.id!);
    }
    _assignIds = ids;
  }

  List<int> get assignIds => _assignIds;

  set assignee(value) => _assignIds = value;
  set activeOwnerIndex(value) {
    _activeOwnerIndex = value;
    notifyListeners();
  }

  get activeOwnerIndex => _activeOwnerIndex;
  get startDate => _startDate;
  get endDate => _endDate;
  get projectImages => _projectImages;
  get base64Image => _base64Image;

  String converteduint8list() {
    List<String> encodedImages = [];
    for (var image in _projectImages!) {
      encodedImages
          .add("data:image/jpg;base64,${base64.encode(image.toList())}");
    }
    String encodedImagetoString = encodedImages.toString();

    return encodedImagetoString
        .replaceAll(",", ".!.")
        .replaceAll("4.!.", "4,")
        .substring(1, encodedImagetoString.length - 1);
  }

  removeImage(var image) {
    _projectImages!.remove(image);
    notifyListeners();
  }

  clear() {
    _base64Image!.clear();
    _projectImages!.clear();
  }

  setOwner(value, isEdit) {
    _activeOwnerIndex = value;
    if (isEdit) {
      _bodyToEdit.addAll({"customer_id": value.toString()});
    }
    print("Owner : $value");
    notifyListeners();
  }

  set startDate(value) => _startDate = value;
  set endDate(value) => _endDate = value;

  addPicture(pickedFile) {
    if (pickedFile != null) {
      _base64Image = pickedFile.files[0].bytes;
      _projectImages!.add(_base64Image!);

      _base64Image = null;
    }
    notifyListeners();
  }

  void asignUser(int userId) {
    if (!_assignIds.contains(userId)) {
      _assignIdsToAdd.add(userId);
    }
    _assignIds.add(userId);
    notifyListeners();
  }

  void removeAssigne(int id) {
    if (_assignIds.contains(id)) {
      _assignIdsToRemove.add(id);
    }
    _assignIds.remove(id);
    notifyListeners();
  }

  init(projectToEdit, CustomerModel firstCustomer, nameController,
      descriptionController) {
    if (projectToEdit != null) {
      nameController.text = projectToEdit!.name!;
      descriptionController.text = projectToEdit!.description!;
      _startDate = projectToEdit!.startDate!;
      _endDate = projectToEdit!.endDate!;
    }
    notifyListeners();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      _startDate = picked;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) _endDate = picked;
  }

  Future removeAssign(
      {required String listAssignIds, required int projectId}) async {
    var url = Uri.parse("$remove_assign");
    try {
      await http.delete(url, body: {
        "project_id": projectId.toString(),
        "assignee_ids": listAssignIds
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        // _projects!.removeWhere((element) => element.id == id);
        // projectsDateBase!.removeWhere((element) => element.id == id);
        // notifyListeners();
        // if (_projects!.length == 0) {
        //   if (_pagination.isPrev) {
        //     paginationService.prevPage(_pagination);
        //   }
        // }
        var data = json.decode(response.body);
        print(data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future assign({required String listAssignIds, required int projectId}) async {
    var url = Uri.parse("$assign_user");
    try {
      await http.post(url, body: {
        "project_id": projectId.toString(),
        "assignee_ids": listAssignIds
      }, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        // _projects!.removeWhere((element) => element.id == id);
        // projectsDateBase!.removeWhere((element) => element.id == id);
        // notifyListeners();
        // if (_projects!.length == 0) {
        //   if (_pagination.isPrev) {
        //     paginationService.prevPage(_pagination);
        //   }
        // }
        var data = json.decode(response.body);
        print("ASSIGN : $data");
      });
    } catch (e) {
      print(e);
    }
  }
}
