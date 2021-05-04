import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/employee/employee_list.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/map.dart';

class EmployeeDetails extends StatefulWidget {
  final EmployeesModel? employeesModel;

  const EmployeeDetails({Key? key, required this.employeesModel})
      : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> with SettingsHelper {
  List<ProjectModel> employeeProjects = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
      employeeProjects = Provider.of<EmployeeSevice>(context, listen: false)
          .usersProjects(widget.employeesModel!.id,
              Provider.of<ProjectProvider>(context, listen: false).projects);

      print(employeeProjects.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    return Container(
        color: Palette.contentBackground,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: AdaptiveContainer(children: [
          AdaptiveItem(
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(
                      context, employeeSevice.setPageScreen, EmployeeList()),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.height * .15,
                        height: MediaQuery.of(context).size.height * .15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10000),
                            color: Colors.grey.shade100,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade400,
                                offset: Offset(3, 3),
                                blurRadius: 2,
                              )
                            ],
                            image: DecorationImage(
                                fit: widget.employeesModel!.picture == null
                                    ? BoxFit.scaleDown
                                    : BoxFit.cover,
                                alignment:
                                    widget.employeesModel!.picture == null
                                        ? AlignmentDirectional.bottomCenter
                                        : AlignmentDirectional.center,
                                image: fetchImage(
                                    netWorkImage:
                                        widget.employeesModel?.picture),
                                scale: widget.employeesModel!.picture == null
                                    ? 5
                                    : 1)),
                      ),
                      SizedBox(
                        width: MySpacer.medium,
                      ),
                      Text(
                        "${widget.employeesModel!.fname} ${widget.employeesModel!.lname}",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Téléphone", style: transHeader),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text("${widget.employeesModel!.contactNumber!}",
                                style: boldText)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: transHeader),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text(
                              "${widget.employeesModel!.email!}",
                              style: boldText,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Adresse", style: transHeader),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text("${widget.employeesModel!.address!}",
                                style: boldText)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  //TODO: Assign projext
                  Text(
                    "Sites Attribués",
                    style: Theme.of(context).textTheme.headline5,
                  ),

                  for (ProjectModel project in employeeProjects)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name!,
                          style: boldText,
                        ),
                        SizedBox(
                          height: MySpacer.small,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Description", style: transHeader),
                                  Text(project.description!),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Total des Heures Travaillées",
                                      style: transHeader),
                                  Text(
                                    "32HRS",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Status", style: transHeader),
                                  Text("En cours"),
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset("assets/images/dashLine.png")),
                        SizedBox(
                          height: MySpacer.large,
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
          AdaptiveItem(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Chantier emplacement",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: MySpacer.medium,
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: MapScreen(),
                          )),
                      SizedBox(
                        height: MySpacer.large,
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Avertissements récents et mise à jour",
                                      style: boldText,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.add_circle),
                                        onPressed: () {
                                          //LOGS
                                        })
                                  ],
                                ),
                                SizedBox(
                                  height: MySpacer.small,
                                ),
                                Expanded(
                                  child: Container(
                                    child: ListView(
                                      children: [
                                        Card(
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.notification_important),
                                            title: Row(
                                              children: [
                                                Text("Chantier"),
                                                SizedBox(
                                                  width: MySpacer.small,
                                                ),
                                                Text("Avril")
                                              ],
                                            ),
                                            subtitle: Text(
                                                "Attention, il nous manque les plaques pour le toit de la terrasse"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.notification_important),
                                            title: Row(
                                              children: [
                                                Text("Chantier"),
                                                SizedBox(
                                                  width: MySpacer.small,
                                                ),
                                                Text("Avril")
                                              ],
                                            ),
                                            subtitle: Text(
                                                "Attention, il nous manque les plaques pour le toit de la terrasse"),
                                          ),
                                        ),
                                        Card(
                                          child: ListTile(
                                            leading: Icon(
                                                Icons.notification_important),
                                            title: Row(
                                              children: [
                                                Text("Chantier"),
                                                SizedBox(
                                                  width: MySpacer.small,
                                                ),
                                                Text("Avril")
                                              ],
                                            ),
                                            subtitle: Text(
                                                "Attention, il nous manque les plaques pour le toit de la terrasse"),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  )))
        ]));
  }
}
