import 'package:flutter/material.dart';

class ScaffoldService extends ChangeNotifier {
  dynamic? _selectedContent;
  int _selectedIndex = 0;

  get selectedContent => _selectedContent;
  get selectedIndex => _selectedIndex;

  set selectedContent(value) {
    _selectedContent = value;
    notifyListeners();
  }

  set selectedIndex(value) {
    _selectedIndex = value;
    notifyListeners();
  }

  init(value) {
    _selectedContent = value;
  }
}
