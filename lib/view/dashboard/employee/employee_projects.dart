import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/user_project_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/settings/helper.dart';

class EmployeeProjectsDetails extends StatefulWidget {
  final EmployeesModel? emplyoyee;

  const EmployeeProjectsDetails({Key? key, required this.emplyoyee})
      : super(key: key);
  @override
  _EmployeeProjectsDetailsState createState() =>
      _EmployeeProjectsDetailsState();
}

class _EmployeeProjectsDetailsState extends State<EmployeeProjectsDetails>
    with SettingsHelper {
  bool loader = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<EmployeeSevice>(context, listen: false)
          .workingProjects(widget.emplyoyee!.id!)
          .whenComplete(() {
        setState(() {
          loader = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var employeeService = Provider.of<EmployeeSevice>(context);
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 5,
      height: size.height * 0.3,
      constraints: BoxConstraints(maxWidth: 800, maxHeight: size.height / 1.8),
      child: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Palette.drawerColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: fetchImage(
                              netWorkImage: widget.emplyoyee!.picture),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.emplyoyee!.fname} ${widget.emplyoyee!.lname}",
                                style: TextStyle(color: Colors.white),
                              ),
                              MediaQuery.of(context).size.width < 1300
                                  ? Text(
                                      "Projets totaux: ${employeeService.employeeProjects != null && employeeService.employeeProjects!.length > 0 ? employeeService.employeeProjects!.length : 0} ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                        Spacer(),
                        MediaQuery.of(context).size.width > 1300
                            ? Text(
                                "Projets totaux: ${employeeService.employeeProjects != null && employeeService.employeeProjects!.length > 0 ? employeeService.employeeProjects!.length : 0} ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ),
                employeeService.employeeProjects != null && loader
                    ? employeeService.employeeProjects!.length == 0
                        ? Expanded(
                            child: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/empty.png",
                                    width: 100,
                                  ),
                                  Text("Pas encore de projets!"),
                                ],
                              ),
                            ),
                          ))
                        : Expanded(
                            child: ListView(
                              children: [
                                employeeService.employeeProjects!.length > 0
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          "Projets Actuels",
                                          style: boldText,
                                        ),
                                      )
                                    : SizedBox(),
                                for (UserProjectModel project
                                    in employeeService.employeeProjects!)
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3)),
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: colorsSettings[project
                                                    .userProject!.status!]
                                                .color,
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
                                // Text("Projet précédent"),
                              ],
                            ),
                          )
                    : Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ]),
          Positioned(
            top: -7,
            right: -7,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Palette.background, shape: BoxShape.circle),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
