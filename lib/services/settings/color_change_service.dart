import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';

class ColorChangeService extends ChangeNotifier {
  List<Color> statusColors = [
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.blue
  ];

  List<String> imagesStatus = [
    "assets/icons/green.png",
    "assets/icons/orange.png",
    "assets/icons/red.png",
    "assets/icons/blue.png"
  ];

  void changeColor(color, index) {
    statusColors[index] = color;

    String newColor = defaultImageTag[defaultColors.indexOf(color)];
    imagesStatus[index] = newColor;
    notifyListeners();
  }
}
