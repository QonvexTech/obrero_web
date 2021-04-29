import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/view/dashboard/customer/customer_screen.dart';

class DashboardService extends ChangeNotifier {
  Widget clientPage = CustomerScreen();
  DatePickerController dateController = DatePickerController();
  DateTime _startDate = DateTime.now();
  DateTime? tempDate;

  List months = [
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
