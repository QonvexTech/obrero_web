import 'package:flutter/material.dart';

class PaginationService extends ChangeNotifier {
  bool _isNext = false;
  bool _isPrev = false;
  int _perPage = 10;

  int? lastPage;
  int _page = 1;

  get getNext => _isNext;
  get getPrev => _isPrev;
  get page => _page;
  get perPage => _perPage;

  set isNext(bool value) {
    _isNext = value;
    notifyListeners();
  }

  set isPrev(bool value) {
    _isPrev = value;
    notifyListeners();
  }

  void nextPage(Function fetch) {
    _page += 1;
    _isNext = false;
    fetch();
  }

  void prevPage(Function fetch) {
    _page -= 1;
    _isPrev = false;
    fetch();
  }

  void setTablePage(int value, Function fetch) {
    _isNext = false;
    _isPrev = false;
    _page = value;
    fetch();
  }
}
