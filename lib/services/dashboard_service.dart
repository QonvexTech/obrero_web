import 'package:flutter/material.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_screen.dart';

class DashboardService extends ChangeNotifier {
  Widget clientPage = Customer();

  get projectPage => clientPage;
  set projectPage(value) {
    clientPage = value;
    notifyListeners();
  }
}
