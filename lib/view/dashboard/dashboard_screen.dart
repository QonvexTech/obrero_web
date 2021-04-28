import 'package:adaptive_container/adaptive_container.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/widgets/emtylist.dart';
import 'package:uitemplate/widgets/map.dart';
import 'package:uitemplate/widgets/map_details.dart';
import 'package:uitemplate/widgets/project_card.dart';

//remove stat
//add it to list
//adjustnotificaiotn

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    var projectsService = Provider.of<ProjectProvider>(context, listen: false);
    projectsService.fetchProjectsBaseOnDates().whenComplete(() =>
        Provider.of<MapService>(context, listen: false)
            .mapInit(projectsService.projects));

    Provider.of<CustomerService>(context, listen: false).fetchCustomers();
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
      DashboardService dashboardService =
          Provider.of<DashboardService>(context);

      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AdaptiveContainer(children: [
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
                //TODO: If need to add date at top
                // MaterialButton(
                //   onPressed: () {
                //     projectProvider.selectDate(context);
                //   },
                //   child: Text(
                //     "${dashboardService.months[projectProvider.selectedDate.month]} ${projectProvider.selectedDate.day}, ${projectProvider.selectedDate.year} ",
                //     style: boldText,
                //   ),
                // ),
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
                                print("selected date");
                                Provider.of<ProjectProvider>(context,
                                        listen: false)
                                    .fetchProjectsBaseOnDates(
                                        dateSelected: date)
                                    .whenComplete(() => Provider.of<MapService>(
                                            context,
                                            listen: false)
                                        .mapInit(
                                            projectProvider.projectDateBased));
                              },
                              width: 75,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
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
                    ),
                  ),
                ),
                // projectProvider.projectDateBased.length > 0
                //     ? Container(
                //         padding: EdgeInsets.symmetric(vertical: 20),
                //         child: MapDetails(
                //           project: projectProvider.projectDateBased,
                //         ))
                //     : SizedBox(),
                SizedBox(
                  height: MySpacer.small,
                ),
                Expanded(
                  child: MapScreen(
                    projects: projectProvider.projectDateBased,
                  ),
                )
              ],
            ),
          )),
          AdaptiveItem(
            height: MediaQuery.of(context).size.width > 900
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height * .5,
            content: projectProvider.projectDateBased.length <= 0
                ? Container(
                    width: 200,
                    height: 500,
                    color: Palette.contentBackground,
                    child: EmtyList(
                      addingFunc: ProjectAddScreen(),
                      title: "No projects yet",
                      description:
                          "Its time to create a project \n choose the right client and location for your project",
                      buttonText: "Créer",
                      showButton: true,
                    ),
                  )
                : Container(
                    color: Palette.contentBackground,
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                        itemCount: projectProvider.projectDateBased.length,
                        itemBuilder: (context, index) {
                          ProjectModel data =
                              projectProvider.projectDateBased[index];
                          return ProjectCard(
                            startDate: projectProvider
                                        .projectDateBased[index].startDate ==
                                    null
                                ? DateTime.now()
                                : projectProvider
                                    .projectDateBased[index].startDate!,
                            name: projectProvider.projectDateBased[index].name!,
                            description: projectProvider
                                        .projectDateBased[index].description ==
                                    null
                                ? ""
                                : projectProvider
                                    .projectDateBased[index].description!,
                            coordinates: data.coordinates!,
                          );
                        }),
                  ),
          )
        ]),
      );
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.drawerColor),
        ),
      );
    }
  }
}
