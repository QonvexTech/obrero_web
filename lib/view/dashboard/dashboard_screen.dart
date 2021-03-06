import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/widgets/mypicker.dart';
import 'package:uitemplate/widgets/project_card.dart';
import 'package:uitemplate/widgets/empty_container.dart';
import 'package:uitemplate/services/settings/helper.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool listCardloader = true;
  int activeProjectInMap = 0;

  @override
  void initState() {
    Provider.of<ProjectProvider>(context, listen: false)
        .fetchProjectsBaseOnDates(context: context)
        .whenComplete(() {
      setState(() {
        listCardloader = false;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<MapService>(context, listen: false).mapInit(
          Provider.of<ProjectProvider>(context, listen: false).projectsDateBase,
          context,
        );
        Provider.of<ProjectProvider>(context, listen: false)
            .dateController
            .jumpToSelection(DateTime.now());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(
      context,
    );
    DashboardService dashboardService = Provider.of<DashboardService>(
      context,
    );
    MapService mapService = Provider.of<MapService>(
      context,
    );

    return Container(
      child: AdaptiveContainer(
          physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
          children: [
            AdaptiveItem(
                content: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              color: Palette.contentBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          projectProvider
                              .selectDate(
                                  context: context,
                                  mapService: mapService,
                                  isNow: false,
                                  controllerDate:
                                      projectProvider.dateController)
                              .then((date) {
                            projectProvider.setSelectedDate(date);
                          });
                        },
                        child: Text(
                          "${months[projectProvider.selectedDate.month]} ${projectProvider.selectedDate.day}, ${projectProvider.selectedDate.year} ",
                          style: boldText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: MaterialButton(
                          onPressed: () {
                            projectProvider
                                .selectDate(
                                    context: context,
                                    mapService: mapService,
                                    isNow: true,
                                    controllerDate:
                                        projectProvider.dateController)
                                .then((date) {
                              projectProvider.setSelectedDate(date);
                            });
                          },
                          child: Text(
                            "Aujourd'hui",
                            style: TextStyle(color: Palette.drawerColor),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    color: Palette.contentBackground,
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Palette.drawerColor,
                                  borderRadius: BorderRadius.circular(100)),
                              child: IconButton(
                                  padding: EdgeInsets.all(5),
                                  constraints: BoxConstraints(
                                      minWidth: 15, minHeight: 15),
                                  iconSize: 20,
                                  onPressed: () {
                                    projectProvider.prevDate(
                                        context, mapService);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: DatePicker2(
                                DateTime(2021, 1, 1),
                                selectionColor: Palette.drawerColor,
                                selectedTextColor: Colors.white,
                                deactivatedColor: Palette.contentBackground,
                                locale: "fr_FR",
                                controller: projectProvider.dateController,
                                onDateChange: (date) {
                                  print(date);

                                  projectProvider.fetchOnDates(
                                      context: context, mapService: mapService);
                                },
                                width: 75,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Palette.drawerColor,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: IconButton(
                                      padding: EdgeInsets.all(5),
                                      constraints: BoxConstraints(
                                          minWidth: 15, minHeight: 15),
                                      iconSize: 20,
                                      onPressed: () {
                                        projectProvider.nextDate(
                                            context, mapService);
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                        color: Colors.white,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width > 800
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 0.4,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onVerticalDragDown: (x) {
                            if (mapService.gesture == false) {
                              mapService.gesture = true;
                            }
                          },
                          child: Stack(
                            children: [
                              GoogleMap(
                                scrollGesturesEnabled: mapService.gesture,
                                onMapCreated: (controller) {
                                  setState(() {
                                    dashboardService.mapController = controller;
                                    // if (projectProvider.projectsDateBase !=
                                    //     null) {
                                    //   if (projectProvider
                                    //           .projectsDateBase.length >
                                    //       0) {
                                    //     dashboardService.mapController!
                                    //         .showMarkerInfoWindow(MarkerId(
                                    //             projectProvider
                                    //                 .projectsDateBase[0].id
                                    //                 .toString()));
                                    //   }
                                    // }
                                  });
                                },
                                myLocationButtonEnabled: true,
                                rotateGesturesEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: initialPositon,
                                  zoom: mapService.zoom,
                                ),
                                buildingsEnabled: true,
                                mapType: MapType.none,
                                myLocationEnabled: true,
                                markers: mapService.markers,
                                circles: mapService.circles,
                              ),
                              dashboardService.projectSelected == null
                                  ? Container()
                                  : AnimatedPositioned(
                                      bottom: dashboardService.showWindow
                                          ? 0
                                          : -250,
                                      right: 50,
                                      duration: Duration(milliseconds: 250),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(20),
                                        width: 300,
                                        height: 125,
                                        child: Card(
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        dashboardService
                                                            .projectSelected!
                                                            .name!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(dashboardService
                                                          .projectSelected!
                                                          .address!),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  MediaQuery.of(context).size.width > 800
                      ? SizedBox()
                      : Expanded(child: listProjects(projectProvider))
                ],
              ),
            )),
            AdaptiveItem(
                bgColor: Palette.contentBackground,
                height: MediaQuery.of(context).size.width > 900
                    ? MediaQuery.of(context).size.height
                    : MediaQuery.of(context).size.height * .7,
                content: Padding(
                  padding:
                      const EdgeInsets.only(top: 50, right: 20, bottom: 100),
                  child: listProjects(projectProvider),
                ))
          ]),
    );
  }

  Widget listProjects(projectProvider) {
    return Container(
      color: Palette.contentBackground,
      child: listCardloader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : projectProvider.projectsDateBase.length <= 0
              ? Container(
                  height: 100,
                  child: EmptyContainer(
                    addingFunc: ProjectAddScreen(),
                    title: "Aucun projet cette fois",
                    description:
                        "Il est temps de cr??er un projet\n choisissez le bon client et le bon emplacement pour votre projet.",
                    buttonText: "Cr??er",
                    showButton: true,
                  ))
              : Container(
                  color: Palette.contentBackground,
                  child: ListView.builder(
                      itemCount: projectProvider.projectsDateBase.length,
                      itemBuilder: (context, index) {
                        return ProjectCard(
                          project: projectProvider.projectsDateBase[index],
                          lastIndex: index ==
                              projectProvider.projectsDateBase.length - 1,
                        );
                      }),
                ),
    );
  }
}
