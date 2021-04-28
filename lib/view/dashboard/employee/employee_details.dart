import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/view/dashboard/employee/employee_list.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/map.dart';

class EmployeeDetails extends StatelessWidget {
  final EmployeesModel? employeesModel;

  const EmployeeDetails({Key? key, required this.employeesModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    return Container(
      color: Palette.contentBackground,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(
                      context, employeeSevice.setPageScreen, EmployeeList()),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                      ),
                      SizedBox(
                        width: MySpacer.small,
                      ),
                      Text(
                        "${employeesModel!.fname!} ${employeesModel!.lname!}",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        width: MySpacer.large,
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
                            Text("${employeesModel!.contactNumber!}",
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
                              "${employeesModel!.email!}",
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
                            Text("${employeesModel!.address!}", style: boldText)
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
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Text("Chantier XYZ"),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address",
                              style: transHeader,
                            ),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text(
                              "LOREM IPSUM DOLOR",
                              style: boldText,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total des Heures Travaillées",
                              style: transHeader,
                            ),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text(
                              "32HRS",
                              style: boldText.copyWith(color: Colors.green),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Status",
                              style: transHeader,
                            ),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text(
                              "En cours",
                              style: boldText,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  // Text(
                  //   "Description",
                  //   style: transHeader,
                  // ),
                  // SizedBox(
                  //   height: MySpacer.small,
                  // ),
                  // Text("${employeesModel!.!}")
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(50),
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
        ],
      ),
    );
  }
}
