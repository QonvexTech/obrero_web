import 'package:flutter/material.dart';
import 'package:uitemplate/models/pagination_model.dart';

class PaginationService extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  TextEditingController perPageController = TextEditingController();

  void customPerPage(PaginationModel page, int newPerPage) {
    page.perPage = newPerPage;
    page.isNext = false;
    page.isPrev = false;

    page.fetch();
    notifyListeners();
  }

  void nextPage(PaginationModel page) {
    page.page += 1;
    page.isNext = false;
    animate(20);
    page.fetch();
    notifyListeners();
  }

  void animate(double offset) {
    scrollController.animateTo(offset,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void prevPage(PaginationModel page) {
    page.page -= 1;
    page.isPrev = false;
    animate(-20);
    page.fetch();
    notifyListeners();
  }

  void setTablePage(int value, PaginationModel page) {
    page.isNext = false;
    page.isPrev = false;
    animate(value > page.page ? 20 : -20);
    page.page = value;
    page.fetch();
    notifyListeners();
  }
}
