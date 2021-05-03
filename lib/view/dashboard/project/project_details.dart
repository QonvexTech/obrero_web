import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';
import 'package:uitemplate/widgets/back_button.dart';

class ProjectDetails extends StatefulWidget {
  final ProjectModel? projectModel;

  const ProjectDetails({Key? key, required this.projectModel})
      : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> with SettingsHelper {
  List<EmployeesModel> assignee = [];
  @override
  void initState() {
    assignee = EmployeesModel.fromJsonListToUsersInProject(
        widget.projectModel!.assignees!);
    print(assignee.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Palette.contentBackground,
      child: AdaptiveContainer(children: [
        AdaptiveItem(
          content: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                backButton(context, projectProvider.setPage, ProjectList()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.projectModel!.name!,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            "Planifié du ${widget.projectModel!.startDate.toString().split(" ")[0]} au ${widget.projectModel!.endDate.toString().split(" ")[0]} ",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("AreaSize", style: transHeader),
                        SizedBox(
                          height: MySpacer.small,
                        ),
                        Text(widget.projectModel!.areaSize.toString(),
                            style: boldText)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Location", style: transHeader),
                        SizedBox(
                          height: MySpacer.small,
                        ),
                        Text(
                          "${widget.projectModel!.coordinates!.latitude},${widget.projectModel!.coordinates!.longitude}",
                          style: boldText,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Owner", style: transHeader),
                        SizedBox(
                          height: MySpacer.small,
                        ),
                        Text(widget.projectModel!.customerId.toString(),
                            style: boldText)
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
                Text(
                  "Description",
                  style: transHeader,
                ),
                SizedBox(
                  height: MySpacer.small,
                ),
                Text(widget.projectModel!.description!),
                SizedBox(
                  height: MySpacer.large,
                ),
                Text(
                  "Personnes intervenant sur le chantier",
                  style: transHeader,
                ),
                SizedBox(
                  height: MySpacer.small,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var x in assignee)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 80,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Palette.contentBackground,
                                backgroundImage:
                                    fetchImage(netWorkImage: x.picture),
                              ),
                              SizedBox(
                                width: MySpacer.small,
                              ),
                              Text(
                                "${x.fname!} ${x.lname!}",
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
                Text(
                  "Photo",
                  style: transHeader,
                ),
                SizedBox(
                  height: MySpacer.small,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Container(
                              color: Colors.red,
                            )),
                            Text("Title")
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        AdaptiveItem(
            content: Container(
          color: Palette.contentBackground,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Statistics",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: MySpacer.small,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Heures Totales",
                        style: transHeader.copyWith(fontSize: 10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "126",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "/hrs",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        "Heures Totales",
                        style: transHeader.copyWith(fontSize: 10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "126",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "/hrs",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        "Heures Totales",
                        style: transHeader.copyWith(fontSize: 10),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "126",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "/hrs",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MySpacer.large,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Warnings",
                    style: Theme.of(context).textTheme.headline6,
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
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.notification_important),
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
                        leading: Icon(Icons.notification_important),
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
                        leading: Icon(Icons.notification_important),
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
            ],
          ),
        ))
      ]),
    );
  }
}
