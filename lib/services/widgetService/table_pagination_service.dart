import 'package:flutter/material.dart';
import 'package:uitemplate/models/pagination_model.dart';

class PaginationService extends ChangeNotifier {
  void nextPage(PaginationModel page) {
    page.page += 1;
    page.isNext = false;
    page.fetch();
    notifyListeners();
  }

  void prevPage(PaginationModel page) {
    page.page -= 1;
    page.isPrev = false;
    page.fetch();
    notifyListeners();
  }

  void setTablePage(int value, PaginationModel page) {
    page.isNext = false;
    page.isPrev = false;
    page.page = value;
    page.fetch();
    notifyListeners();
  }
}
