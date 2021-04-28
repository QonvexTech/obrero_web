import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/view/dashboard/customer/customer_screen.dart';

class DashboardService extends ChangeNotifier {
  Widget clientPage = Customer();
  DatePickerController dateController = DatePickerController();
  DateTime _minDate = DateTime.now();
  DateTime onView = DateTime.now();

  get startDate => _minDate;
  get projectPage => clientPage;

  void nextDate() {
    var newDate = onView.add(Duration(days: 5));
    dateController.animateToDate(newDate);
    notifyListeners();
  }

  void prevDate() {
    _minDate = startDate.subtract(Duration(days: 5));
    notifyListeners();
  }

  set projectPage(value) {
    clientPage = value;
    notifyListeners();
  }
}
