import 'package:flutter/material.dart';
import 'package:uitemplate/ui_pack/children/drawer_item.dart';

class ScaffoldService extends ChangeNotifier {
  Widget? _selectedContent;
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
    notifyListeners();
  }
}
