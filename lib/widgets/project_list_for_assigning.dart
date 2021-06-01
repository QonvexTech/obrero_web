import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';

class ProjectListAssign extends StatelessWidget {
  final EmployeesModel? userId;

  const ProjectListAssign({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    return Expanded(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          ProjectList(
            assignUser: true,
            userToAssign: userId,
          ),
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    ));
  }
}
