import 'package:flutter/material.dart';

class ProjectAddViewModel {
  ProjectAddViewModel._private();
  static final ProjectAddViewModel _instance = ProjectAddViewModel._private();
  static ProjectAddViewModel get instance => _instance;

  final TextEditingController _address = new TextEditingController();
  TextEditingController get addressField => _address;
}
