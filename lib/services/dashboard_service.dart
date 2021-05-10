import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/view/dashboard/customer/customer_screen.dart';

class DashboardService extends ChangeNotifier {
  Widget clientPage = CustomerScreen();
  DatePickerController dateController = DatePickerController();
  DateTime _startDate = DateTime.now();
  DateTime? tempDate;
  int _selectedProject = 0;

  initGetId(List<ProjectModel> projects) {
    if (projects.length > 0) {
      _selectedProject = projects[0].id!;
    }
  }

  get selectedProject => _selectedProject;
  set selectedPrject(value) {
    _selectedProject = value;
    notifyListeners();
  }

  List months = [
    "",
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre'
  ];

  get startDate => _startDate;

  set startDate(value) {
    _startDate = value;
    notifyListeners();
  }

  get projectPage => clientPage;

  void nextDate() {
    _startDate = startDate.add(Duration(days: 5));
    notifyListeners();
  }

  void prevDate() {
    _startDate = startDate.subtract(Duration(days: 5));
    notifyListeners();
  }

  set projectPage(value) {
    clientPage = value;
    notifyListeners();
  }
}
