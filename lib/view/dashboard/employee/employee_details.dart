import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/models/user_project_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/log_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/settings/color_change_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/employee/employee_list.dart';
import 'package:uitemplate/view_model/logs/loader.dart';
import 'package:uitemplate/widgets/adding_button.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/empty_container.dart';
import 'package:uitemplate/widgets/map.dart';
import 'package:uitemplate/widgets/project_list_for_assigning.dart';

class EmployeeDetails extends StatefulWidget {
  final EmployeesModel? employeesModel;

  const EmployeeDetails({Key? key, required this.employeesModel})
      : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> with SettingsHelper {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<EmployeeSevice>(context, listen: false)
          .workingProjects(widget.employeesModel!.id!)
          .whenComplete(() {
        setMap().whenComplete(() {
          MapService mapService =
              Provider.of<MapService>(context, listen: false);

          mapService.mapController!.showMarkerInfoWindow(MarkerId(
              Provider.of<EmployeeSevice>(context, listen: false)
                  .employeeProjects![0]
                  .userProject!
                  .id!
                  .toString()));

          mapService.mapController!.moveCamera(CameraUpdate.newLatLng(
              Provider.of<EmployeeSevice>(context, listen: false)
                  .employeeProjects![0]
                  .userProject!
                  .coordinates!));
        });
      });
    });
  }

  Future setMap() async {
    print(
        "number : ${Provider.of<EmployeeSevice>(context, listen: false).employeeProjects!.length}");
    if (Provider.of<EmployeeSevice>(context, listen: false)
            .employeeProjects!
            .length >
        0) {
      for (UserProjectModel project
          in Provider.of<EmployeeSevice>(context, listen: false)
              .employeeProjects!) {
        Provider.of<MapService>(context, listen: false).markersAdd(Marker(
            onTap: () {
              try {
                Provider.of<MapService>(context, listen: false)
                    .mapController!
                    .showMarkerInfoWindow(
                        MarkerId(project.userProject!.id.toString()));
              } catch (e) {
                print(e);
              }
            },
            infoWindow: InfoWindow(
                title: project.userProject!.name,
                snippet: project.userProject!.address!.toString()),
            icon: await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(),
                Provider.of<ColorChangeService>(context, listen: false)
                    .imagesStatus[project.userProject!.status!]),
            markerId: MarkerId(project.id.toString()),
            position: project.userProject!.coordinates!));
      }
      // activeProject = Provider.of<EmployeeSevice>(context, listen: false)
      //     .employeeProjects![0]
      //     .id!;

    }
  }

  int activeProject = 0;

  @override
  Widget build(BuildContext context) {
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    MapService mapService = Provider.of<MapService>(context);
    return Container(
      color: Palette.contentBackground,
      padding: EdgeInsets.only(top: 20),
      child: AdaptiveContainer(
          physics:
              ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
          children: [
            AdaptiveItem(
              height: MediaQuery.of(context).size.height,
              content: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: backButton(context, employeeSevice.setPageScreen,
                          EmployeeList()),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height * .12,
                                  height:
                                      MediaQuery.of(context).size.height * .12,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10000),
                                      color: Colors.grey.shade100,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: Offset(3, 3),
                                          blurRadius: 2,
                                        )
                                      ],
                                      image: DecorationImage(
                                          fit: widget.employeesModel!.picture ==
                                                  null
                                              ? BoxFit.scaleDown
                                              : BoxFit.cover,
                                          alignment: widget.employeesModel!
                                                      .picture ==
                                                  null
                                              ? AlignmentDirectional
                                                  .bottomCenter
                                              : AlignmentDirectional.center,
                                          image: fetchImage(
                                              netWorkImage: widget
                                                  .employeesModel?.picture),
                                          scale:
                                              widget.employeesModel!.picture ==
                                                      null
                                                  ? 5
                                                  : 1)),
                                ),
                                SizedBox(
                                  width: MySpacer.medium,
                                ),
                                Flexible(
                                  child: Text(
                                    "${widget.employeesModel!.fname} ${widget.employeesModel!.lname}",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MySpacer.large,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Téléphone", style: transHeader),
                                      SizedBox(
                                        height: MySpacer.small,
                                      ),
                                      Text(
                                          "${widget.employeesModel!.contactNumber!}",
                                          style: boldText)
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Sites Attribués",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                // Container(
                                //   width: 150,
                                //   child: Center(
                                //     child: AddingButton(
                                //         addingPage: ProjectListAssign(
                                //           userId: widget.employeesModel!,
                                //         ),
                                //         buttonText: "Add More"),
                                //   ),
                                // )
                              ],
                            ),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            employeeSevice.employeeProjects == null
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : employeeSevice.employeeProjects!.length == 0
                                    ? EmptyContainer(
                                        addingFunc: null,
                                        title: "No assigned project yet",
                                        description: "",
                                        buttonText: "Assign Projects",
                                        showButton: false,
                                      )
                                    : Column(
                                        children: [
                                          for (UserProjectModel project
                                              in employeeSevice
                                                  .employeeProjects!)
                                            GestureDetector(
                                              onTap: () {
                                                print("Click");
                                                mapService.mapController!
                                                    .showMarkerInfoWindow(
                                                        MarkerId(project.id
                                                            .toString()));
                                                mapService.mapController!
                                                    .moveCamera(
                                                        CameraUpdate.newLatLng(
                                                            project.userProject!
                                                                .coordinates!));

                                                setState(() {
                                                  activeProject = project.id!;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: activeProject ==
                                                                project.id
                                                            ? Palette
                                                                .drawerColor
                                                            : Colors
                                                                .transparent)),
                                                padding: EdgeInsets.all(8),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                constraints: BoxConstraints(
                                                    minHeight: 150),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      project
                                                          .userProject!.name!,
                                                      style: boldText,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Description",
                                                                  style:
                                                                      transHeader),
                                                              ReadMoreText(
                                                                project
                                                                    .userProject!
                                                                    .description!,
                                                                trimLines: 1,
                                                                trimLength: 290,
                                                                trimMode:
                                                                    TrimMode
                                                                        .Length,
                                                                trimCollapsedText:
                                                                    'Montre plus',
                                                                trimExpandedText:
                                                                    'Montrer moins',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                moreStyle: TextStyle(
                                                                    color: Palette
                                                                        .drawerColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                lessStyle: TextStyle(
                                                                    color: Palette
                                                                        .drawerColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    "Total des Heures Travaillées",
                                                                    style:
                                                                        transHeader),
                                                                Text(
                                                                  project.employeeHourList!.length >
                                                                              0 &&
                                                                          employeeSevice.getTotalHours(project.employeeHourList!) !=
                                                                              null
                                                                      ? "${employeeSevice.getTotalHours(project.employeeHourList!)}"
                                                                      : "0.00",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: MySpacer
                                                                  .medium,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text("Status",
                                                                    style:
                                                                        transHeader),
                                                                Consumer<
                                                                    ColorChangeService>(
                                                                  builder:
                                                                      (context,
                                                                          data,
                                                                          child) {
                                                                    return Text(
                                                                      statusTitles[project
                                                                          .userProject!
                                                                          .status!],
                                                                      style: TextStyle(
                                                                          color: data.statusColors[project
                                                                              .userProject!
                                                                              .status!]),
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                            SizedBox(
                              height: 150,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AdaptiveItem(
                height: MediaQuery.of(context).size.height,
                content: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(
                      top: 20,
                      right: 20,
                    ),
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
                              child: MapScreen(
                                setCoord: false,
                                onCreate: () {},
                              ),
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: MySpacer.small,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: StreamBuilder<List<LogModel>>(
                                        builder: (context, result) {
                                          if (result.hasError) {
                                            return Center(
                                              child: Text(
                                                "${result.error}",
                                              ),
                                            );
                                          }
                                          if (result.hasData &&
                                              result.data!.length > 0) {
                                            List<LogModel>? warnings() {
                                              List<LogModel> newWarnings = [];
                                              for (LogModel log
                                                  in result.data!) {
                                                if (log.type ==
                                                        "user_time_update" &&
                                                    log.sender_id ==
                                                        widget.employeesModel!
                                                            .id) {
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
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 150,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .notifications_none_sharp,
                                                                    size: 50,
                                                                    color: Colors
                                                                        .grey),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                children: List.generate(
                                                    warnings()!.length,
                                                    (index) =>
                                                        warnings()!.length == 0
                                                            ? Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.2,
                                                                child: Center(
                                                                  child: Text(
                                                                      "Empty logs"),
                                                                ),
                                                              )
                                                            : Card(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .notification_important_rounded,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            ListTile(
                                                                          title:
                                                                              Text("${warnings()![index].data_id}"),
                                                                          subtitle:
                                                                              Text("${warnings()![index].body}"),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
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
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )))
          ]),
    );
  }
}
