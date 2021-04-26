import 'package:flutter/material.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/project_model.dart';

class ProjectAddService extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool _isEdit = false;
  List<int> _assignee = [];
  int _activeOwnerIndex = 0;

  List<int> get assignee => _assignee;
  get activeOwnerIndex => _activeOwnerIndex;
  get startDate => _startDate;
  get endDate => _endDate;
  get isEdit => _isEdit;

  set setOwner(value) {
    _activeOwnerIndex = value;
    notifyListeners();
  }

  set isEdit(value) => _isEdit = value;
  set startDate(value) => _startDate = value;
  set endDate(value) => _endDate = value;

  void asignUser(int userId) {
    _assignee.add(userId);
    notifyListeners();
  }

  void removeAssigne(int id) {
    _assignee.remove(id);
    notifyListeners();
  }

  init(projectToEdit, CustomerModel firstCustomer) {
    if (projectToEdit != null) {
      print("not null");
      isEdit = true;
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
    if (picked != null && picked != startDate) _startDate = picked;
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) _endDate = picked;
  }

  void submit(
      {required projectToEdit,
      required projectService,
      required coordinates,
      required context}) {
    if (isEdit) {
      projectToEdit!.name = nameController.text;
      projectToEdit!.customerId = projectToEdit!.customerId;
      projectToEdit!.description = descriptionController.text;
      projectToEdit!.coordinates = projectToEdit!.coordinates;
      projectToEdit!.startDate = startDate;
      projectToEdit!.endDate = endDate;
      projectService.updateProject(newProject: projectToEdit);
    } else {
      ProjectModel newProject = ProjectModel(
          assignee: _assignee,
          customerId: _activeOwnerIndex,
          description: descriptionController.text,
          name: nameController.text,
          coordinates: coordinates,
          startDate: startDate,
          endDate: endDate);

      projectService
          .createProjects(
            newProject: newProject,
          )
          .whenComplete(() => Navigator.pop(context));
    }
  }
}
