import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/employee_service.dart';

class EmployeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EmployeeSevice customerService = Provider.of<EmployeeSevice>(context);
    return customerService.activePageScreen;
  }
}
