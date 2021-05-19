import 'package:adaptive_container/adaptive_container.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/color_change_service.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/widgets/map.dart';
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
          Provider.of<ColorChangeService>(context, listen: false).imagesStatus);
      Provider.of<DashboardService>(context, listen: false)
          .initGetId(projectProvider.projectsDateBase);
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

    return AdaptiveContainer(
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
                                controllerDate: dashboardService.dateController)
                            .then((date) {
                          dashboardService.startDate = date;
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
                                      dashboardService.dateController)
                              .then((date) {
                            dashboardService.startDate = date;
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
                                constraints:
                                    BoxConstraints(minWidth: 15, minHeight: 15),
                                iconSize: 20,
                                onPressed: () {
                                  dashboardService.prevDate();
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
                            child: DatePicker(
                              dashboardService.startDate,
                              initialSelectedDate: projectProvider.selectedDate,
                              selectionColor: Palette.drawerColor,
                              selectedTextColor: Colors.white,
                              deactivatedColor: Palette.contentBackground,
                              locale: "fr_FR",
                              controller: dashboardService.dateController,
                              onDateChange: (date) {
                                //New Date

                                projectProvider
                                    .fetchProjectsBaseOnDates(
                                        dateSelected: date,
                                        controller:
                                            dashboardService.dateController)
                                    .whenComplete(() => mapService.mapInit(
                                        projectProvider.projectsDateBase,
                                        context,
                                        Provider.of<ColorChangeService>(context)
                                            .imagesStatus));
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
                                      dashboardService.nextDate();
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
                  child: MapScreen(
                    setCoord: false,
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
                  : MediaQuery.of(context).size.height * .5,
              content: Padding(
                padding: const EdgeInsets.only(top: 50, right: 20),
                child: listProjects(projectProvider),
              ))
        ]);
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
                  width: 200,
                  height: 500,
                  color: Palette.contentBackground,
                  child: EmptyContainer(
                    addingFunc: ProjectAddScreen(),
                    title: "No projects yet",
                    description:
                        "Its time to create a project \n choose the right client and location for your project",
                    buttonText: "Créer",
                    showButton: true,
                  ))
              : Container(
                  color: Palette.contentBackground,
                  child: ListView.builder(
                      itemCount: projectProvider.projectsDateBase.length,
                      itemBuilder: (context, index) {
                        return ProjectCard(
                            project: projectProvider.projectsDateBase[index]);
                      }),
                ),
    );
  }
}
