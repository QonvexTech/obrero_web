import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/project_service.dart';

class Project extends StatefulWidget {
  @override
  _ProjectState createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  @override
  Widget build(BuildContext context) {
    ProjectProvider projectService = Provider.of<ProjectProvider>(context);
    return projectService.activePageScreen;
  }
}
