import 'package:flutter/material.dart';
import 'package:uitemplate/models/pagination_model.dart';

class PaginationService extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  void updatePerPage(
    int value,
    PaginationModel page,
  ) {
    page.perPage = value;
    page.isNext = false;
    page.isPrev = false;
    page.fetch();
    notifyListeners();
  }

  void animate(double offset) {
    if (scrollController.positions.isNotEmpty) {
      scrollController.animateTo(offset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }

  void nextPage(PaginationModel page) {
    page.page += 1;
    page.isNext = false;
    animate(20 * double.parse(page.page.toString()));
    page.fetch();
    notifyListeners();
  }

  void prevPage(PaginationModel page) {
    page.page -= 1;
    page.isPrev = false;
    animate(-20 * double.parse(page.page.toString()));
    page.fetch();

    notifyListeners();
  }

  void removeItem(PaginationModel page) {
    page.perPage -= 1;
    page.totalEntries -= 1;
    notifyListeners();
  }

  void addedItem(PaginationModel page) {
    page.perPage -= 1;
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
