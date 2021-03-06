import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
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

  TextEditingController _addressController = TextEditingController();
  bool justScroll = true;

  List<int> _imagesToDelete = [];

  void addImageToDelete(var image) {
    _imagesToDelete.add(image.id);
    notifyListeners();
  }

  get isAddressEmpty => _addressController.text.isEmpty;

  get addressController => _addressController;

  get bodyToEdit => _bodyToEdit;
  set bodyToEdit(value) => _bodyToEdit = value;

  void initbodyToEdit() => _bodyToEdit = {};
  get areaSize => _areaSize;
  set areaSize(value) {
    _areaSize = value;
    notifyListeners();
  }

  set setaddressController(value) {
    _addressController.text = value;
    notifyListeners();
  }

  set initArea(value) {
    _areaSize = value;
  }

  set initAdress(String value) {
    _addressController.text = value;
  }

  get assignIdsToRemove => _assignIdsToRemove;
  get assignIdsToAdd => _assignIdsToAdd;

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

  Future deleteAllImage() async {
    for (var image in _imagesToDelete) {
      removeImageFromApi(image);
    }
    _imagesToDelete = [];
  }

  List<int> get assignIds => _assignIds;

  set assignee(value) => _assignIds = value;
  set activeOwnerIndex(value) {
    _activeOwnerIndex = value;
    notifyListeners();
  }

  set setInitActiveOwner(value) {
    _activeOwnerIndex = value;
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
    print(_projectImages!.length);
    return encodedImagetoString
        .replaceAll(",", ".!.")
        .replaceAll("4.!.", "4,")
        .substring(1, encodedImagetoString.length - 1);
  }

  removeImage(var image, isEdit) {
    _projectImages!.remove(image);

    if (isEdit) {
      _imagesToDelete.add(image.id);
    }

    notifyListeners();
  }

  removeNewImage(var image) {
    _projectImages!.remove(image);
    notifyListeners();
  }

  Future removeImageFromApi(id) async {
    var url = Uri.parse("$api/project/remove_image/$id");
    try {
      await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/x-www-form-urlencoded"
      }).then((response) {
        var data = json.decode(response.body);
        print(data);
        print("deleteSucc");
      });
    } catch (e) {
      print("deleteFail");
      print(e);
    }
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
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        locale: Locale('fr', 'CA'),
        fieldHintText:
            "${_startDate.month}-${_startDate.day}-${_startDate.year}",
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != startDate) {
      _startDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        locale: Locale('fr', 'CA'),
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) _endDate = picked;
    notifyListeners();
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
        var data = json.decode(response.body);
        print("ASSIGN : $data");
      });
    } catch (e) {
      print(e);
    }
  }
}
