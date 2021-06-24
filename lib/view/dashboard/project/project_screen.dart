import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/project/project_service.dart';

class ProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProjectProvider projectService = Provider.of<ProjectProvider>(context);
    return projectService.activePageScreen;
  }
}
