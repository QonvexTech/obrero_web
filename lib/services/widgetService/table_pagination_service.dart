import 'package:flutter/material.dart';
import 'package:uitemplate/models/pagination_model.dart';

class PaginationService extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  int _value = 10;

  List<DropdownMenuItem<int>> perPageList = [];

  void loadperPageList(PaginationModel page) {
    perPageList = [];
    _value = page.perPage;
    for (var x = 1; x <= page.totalEntries; x++) {
      perPageList.add(new DropdownMenuItem(
        child: new Text('$x'),
        value: x,
      ));
    }
  }

  get value => _value;

  void updatePerPage(
    int value,
    PaginationModel page,
  ) {
    this._value = value;

    page.perPage = value;
    page.isNext = false;
    page.isPrev = false;
    page.fetch();
    notifyListeners();
  }

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
    if (scrollController.positions.isNotEmpty) {
      scrollController.animateTo(offset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }
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
