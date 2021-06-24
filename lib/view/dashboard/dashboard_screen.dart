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
import 'package:universal_html/html.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    var projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    projectProvider.fetchProjectsBaseOnDates(context: context).whenComplete(() {
      Provider.of<MapService>(context, listen: false).mapInit(
        projectProvider.projectsDateBase,
        context,
      );
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      projectProvider.dateController.jumpToSelection(DateTime.now());
    });

    print("DASHBOARD SCREEN");
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

    return GestureDetector(
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
                                // initialSelectedDate: projectProvider.selectedDate,
                                selectionColor: Palette.drawerColor,
                                selectedTextColor: Colors.white,
                                deactivatedColor: Palette.contentBackground,
                                locale: "fr_FR",
                                controller: projectProvider.dateController,
                                onDateChange: (date) {
                                  //New Date

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
                        initialPositon == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onVerticalDragDown: (x) {
                                  if (mapService.gesture == false) {
                                    mapService.gesture = true;
                                  }
                                },
                                child: GoogleMap(
                                  scrollGesturesEnabled: mapService.gesture,
                                  onMapCreated: (controller) {
                                    setState(() {
                                      dashboardService.mapController =
                                          controller;
                                      if (projectProvider.projectsDateBase !=
                                          null) {
                                        if (projectProvider
                                                .projectsDateBase.length >
                                            0) {
                                          dashboardService.mapController!
                                              .showMarkerInfoWindow(MarkerId(
                                                  projectProvider
                                                      .projectsDateBase[0].id
                                                      .toString()));
                                        }
                                      }
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
      child: projectProvider.projectsDateBase == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : projectProvider.projectsDateBase.length <= 0
              ? Container(
                  child: EmptyContainer(
                  addingFunc: ProjectAddScreen(),
                  title: "Aucun projet cette fois",
                  description:
                      "Il est temps de créer un projet\n choisissez le bon client et le bon emplacement pour votre projet.",
                  buttonText: "Créer",
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
