import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';

class ColorModels {
  final int? id;
  String? name;
  Color? color;
  String colorName;
  String? circleAsset;
  ColorModels(
      {required this.id,
      required this.color,
      required this.colorName,
      required this.name,
      required this.circleAsset});

  factory ColorModels.fromJson(Map<String, dynamic> json) {
    return ColorModels(
        id: int.parse(json['id'].toString()),
        color: stringToWidget(json['color']),
        colorName: json['color'],
        name: json['name'],
        circleAsset: defaultImageTag['${json['color'].split('.')[1]}']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
      };
  static Color stringToWidget(String data) {
    return colorMap['${data.split('.')[1]}']!;
  }
}
