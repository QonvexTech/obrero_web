import 'package:adaptive_container/adaptive_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/log_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/scaffold_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';
import 'package:uitemplate/view/dashboard/messages/message_screen.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';
import 'package:uitemplate/view_model/logs/loader.dart';
import 'package:uitemplate/widgets/back_button.dart';

class ProjectDetails extends StatefulWidget {
  final String fromPage;

  const ProjectDetails({Key? key, required this.fromPage}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> with SettingsHelper {
  @override
  void initState() {
    Provider.of<ProjectProvider>(context, listen: false).initHours(
        Provider.of<ProjectProvider>(context, listen: false)
            .projectOnDetails
            .id!);
    super.initState();
  }

  bool showWarning = true;
  double warningHeight = 200;

  @override
  Widget build(BuildContext context) {
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);

    var scaff = Provider.of<ScaffoldService>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Palette.contentBackground,
      child: Stack(
        children: [
          AdaptiveContainer(children: [
            AdaptiveItem(
              content: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.fromPage == "dashboard"
                        ? Container()
                        : backButton(
                            context,
                            projectProvider.setPage,
                            widget.fromPage == "project"
                                ? ProjectList(
                                    assignUser: false,
                                  )
                                : CustomerList()),
                    Text(
                      projectProvider.projectOnDetails!.name!,
                      style: Theme.of(context).textTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Planifié du ${months[projectProvider.projectOnDetails!.startDate.month]} ${projectProvider.projectOnDetails!.startDate.day}, ${projectProvider.projectOnDetails!.startDate.year} au ${months[projectProvider.projectOnDetails!.endDate.month]} ${projectProvider.projectOnDetails!.endDate.day}, ${projectProvider.projectOnDetails!.endDate.year} ",
                      overflow: TextOverflow.ellipsis,
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
                            Text(
                                projectProvider.projectOnDetails!.areaSize
                                    .toString(),
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
                              projectProvider.projectOnDetails!.address != null
                                  ? "${projectProvider.projectOnDetails!.address}"
                                  : "${projectProvider.projectOnDetails!.coordinates!.latitude},${projectProvider.projectOnDetails!.coordinates!.longitude}",
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
                            Text(
                                "${projectProvider.projectOnDetails!.owner!.fname!} ${projectProvider.projectOnDetails!.owner!.lname!}",
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
                    Text(projectProvider.projectOnDetails!.description!),
                    SizedBox(
                      height: MySpacer.large,
                    ),
                    Row(
                      children: [
                        Text(
                          "Personnes intervenant sur le chantier",
                          style: transHeader,
                        ),
                        IconButton(
                            onPressed: () {
                              scaff.selectedContent = MessageScreen(
                                  recepients: projectProvider
                                      .projectOnDetails!.assignees!);
                              if (widget.fromPage == "dashboard") {
                                Navigator.pop(context);
                              }
                            },
                            icon: Icon(
                              Icons.message_rounded,
                              color: Palette.drawerColor,
                            ))
                      ],
                    ),
                    projectProvider.projectOnDetails!.assignees!.length <= 0
                        ? DottedBorder(
                            color: Colors.black12,
                            strokeWidth: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                                backgroundColor:
                                                    Palette.contentBackground,
                                                content: ProjectAddScreen(
                                                  projectToEdit: projectProvider
                                                      .projectOnDetails,
                                                )));
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Palette.drawerColor,
                                      ),
                                    ),
                                    Text("Assign Employees"),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.09,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (var x in projectProvider
                                    .projectOnDetails!.assignees!)
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 80,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Palette.contentBackground,
                                          backgroundImage: fetchImage(
                                              netWorkImage: x.picture),
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
                      height: MySpacer.medium,
                    ),
                    projectProvider.projectOnDetails!.images!.length == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Photos",
                                style: transHeader,
                              ),
                              SizedBox(height: MySpacer.small),
                              DottedBorder(
                                color: Colors.black12,
                                strokeWidth: 2,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                    backgroundColor: Palette
                                                        .contentBackground,
                                                    content: ProjectAddScreen(
                                                      projectToEdit:
                                                          projectProvider
                                                              .projectOnDetails,
                                                    )));
                                          },
                                          icon: Icon(
                                            Icons.upload_rounded,
                                            color: Palette.drawerColor,
                                          ),
                                        ),
                                        Text("Upload Image")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: MySpacer.small),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Photos",
                                style: transHeader,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: projectProvider
                                            .projectOnDetails!.images!.length >=
                                        3
                                    ? projectProvider
                                            .projectOnDetails!.images!.length /
                                        3 *
                                        200
                                    : 200,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.count(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  shrinkWrap: true,
                                  childAspectRatio: 1.5,
                                  crossAxisCount: 3,
                                  children: [
                                    for (var image in projectProvider
                                        .projectOnDetails!.images!.reversed)
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: tempImageProvider(
                                                  netWorkImage: image.url,
                                                  defaultImage:
                                                      "images/emptyImage.jpg")),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
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
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Text(
                    "Statistics",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                projectProvider.hours,
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

                      // Column(
                      //   children: [
                      //     Text(
                      //       "Progres Totales",
                      //       style: transHeader.copyWith(fontSize: 10),
                      //     ),
                      //     Row(
                      //       crossAxisAlignment: CrossAxisAlignment.end,
                      //       children: [
                      //         Text(
                      //           "60%",
                      //           style: Theme.of(context).textTheme.headline3,
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: 4,
                          color: Colors.grey,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Avertissement Total",
                            style: transHeader.copyWith(fontSize: 10),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${projectProvider.projectOnDetails!.warnings!.length}",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                "Warning",
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
                    width: MediaQuery.of(context).size.width,
                    height: warningHeight,
                    child: StreamBuilder<List<LogModel>>(
                      builder: (context, result) {
                        if (result.hasError) {
                          return Center(
                            child: Text(
                              "${result.error}",
                            ),
                          );
                        }

                        if (result.hasData && result.data!.length > 0) {
                          List<LogModel>? warnings() {
                            List<LogModel> newWarnings = [];
                            for (LogModel log in result.data!) {
                              if (log.type == "project_warning" &&
                                  log.data_id ==
                                      projectProvider.projectOnDetails!.id) {
                                newWarnings.add(log);
                              }
                            }

                            return newWarnings;
                          }

                          if (warnings()!.length <= 0) {
                            showWarning = false;
                            return Container(
                              height: 50,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 150,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  Icons
                                                      .notifications_none_sharp,
                                                  size: 50,
                                                  color: Colors.grey),
                                              Text(
                                                  "Pas encore d'avertissements!")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            warningHeight = 0;
                          }

                          return SizedBox();
                        } else {
                          return Container(
                            child: LogsLoader.load(),
                          );
                        }
                      },
                      stream: logService.stream$,
                    ),
                  ),
                  showWarning
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: StreamBuilder<List<LogModel>>(
                            builder: (context, result) {
                              if (result.hasError) {
                                return Center(
                                  child: Text(
                                    "${result.error}",
                                  ),
                                );
                              }

                              if (result.hasData && result.data!.length > 0) {
                                List<LogModel>? warnings() {
                                  List<LogModel> newWarnings = [];
                                  for (LogModel log in result.data!) {
                                    if (log.type == "project_warning" &&
                                        log.data_id ==
                                            projectProvider
                                                .projectOnDetails!.id) {
                                      newWarnings.add(log);
                                    }
                                  }

                                  return newWarnings;
                                }

                                if (warnings()!.length <= 0) {
                                  return Container(
                                    height: 50,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Card(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 150,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .notifications_none_sharp,
                                                        size: 50,
                                                        color: Colors.grey),
                                                    Text(
                                                        "Pas encore d'avertissements!")
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Scrollbar(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    children: List.generate(warnings()!.length,
                                        (index) {
                                      return Stack(
                                        children: [
                                          Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .notification_important_rounded,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: ListTile(
                                                      title: Text(
                                                          "${warnings()![index].title}"),
                                                      subtitle: Text(
                                                          "${warnings()![index].body}"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Consumer<ColorChangeService>(
                                          //   builder: (context, data, child) {
                                          //     return Positioned(
                                          //         right: 10,
                                          //         top: 10,
                                          //         child: Container(
                                          //           width: 100,
                                          //           height: 20,
                                          //           decoration: BoxDecoration(
                                          //               color: Colors.grey,
                                          //               // color: data.statusColors[
                                          //               //     int.parse(
                                          //               //         warnings()![index]
                                          //               //             .type!)],
                                          //               borderRadius:
                                          //                   BorderRadius.circular(
                                          //                       10)),
                                          //           child: Text(
                                          //               "${warnings()![index].body!}"),
                                          //         ));
                                          //   },
                                          // ),
                                        ],
                                      );
                                    }),
                                  ),
                                );
                              } else {
                                return Container(
                                  child: LogsLoader.load(),
                                );
                              }
                            },
                            stream: logService.stream$,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ))
          ]),
          widget.fromPage == "dashboard"
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                      splashRadius: 5,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.red)))
              : SizedBox(),
        ],
      ),
    );
  }
}
