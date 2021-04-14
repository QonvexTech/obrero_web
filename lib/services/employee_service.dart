import 'package:flutter/material.dart';
import 'package:uitemplate/screens/dashboard/employee/employee_list.dart';

class EmployeeSevice extends ChangeNotifier {
  Widget activePageScreen = EmployeeList();
  setActivePageScreen(Widget newPage) {
    activePageScreen = newPage;
    notifyListeners();
  }
}
