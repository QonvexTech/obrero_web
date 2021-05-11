import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/user_project_model.dart';
import 'package:uitemplate/services/employee_service.dart';

class EmployeeProjectsDetails extends StatefulWidget {
  final EmployeesModel? emplyoyee;

  const EmployeeProjectsDetails({Key? key, required this.emplyoyee})
      : super(key: key);
  @override
  _EmployeeProjectsDetailsState createState() =>
      _EmployeeProjectsDetailsState();
}

class _EmployeeProjectsDetailsState extends State<EmployeeProjectsDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<EmployeeSevice>(context, listen: false)
          .workingProjects(widget.emplyoyee!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    var employeeService = Provider.of<EmployeeSevice>(context);
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 5,
      height: size.height,
      constraints: BoxConstraints(maxWidth: 800, maxHeight: size.height / 1.8),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  CircleAvatar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("John Doe"),
                  )
                ],
              ),
            ),
            employeeService.employeeProjects != null
                ? Expanded(
                    child: ListView(
                      children: [
                        Text("Projets Actuels"),
                        for (UserProjectModel project
                            in employeeService.employeeProjects!)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: statusColors[
                                        project.userProject!.status!],
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: MySpacer.small,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${project.userProject!.name}",
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: MySpacer.medium,
                        ),
                        Text("Projet précédent"),
                      ],
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ]),
    );
  }
}
