import 'package:adaptive_container/adaptive_container.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
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

      return AdaptiveContainer(children: [
        AdaptiveItem(
            height: MediaQuery.of(context).size.height,
            content: Container(
              padding: EdgeInsets.all(20),
              color: Palette.contentBackground,
              child: Column(
                children: [
                  Container(
                    color: Palette.contentBackground,
                    child: Card(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                dashboardService.prevDate();
                              },
                              icon: Icon(Icons.arrow_back_ios_rounded)),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: DatePicker(
                              dashboardService.startDate,
                              initialSelectedDate: projectProvider.selectedDate,
                              selectionColor: Palette.drawerColor,
                              selectedTextColor: Colors.white,
                              locale: "fr_FR",
                              controller: dashboardService.dateController,
                              onDateChange: (date) {
                                //New Date
                                print("selected date");
                                Provider.of<ProjectProvider>(context,
                                        listen: false)
                                    .fetchProjectsBaseOnDates(
                                        dateSelected: date);
                              },
                              width: 75,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                              onPressed: () {
                                dashboardService.nextDate();
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded))
                        ],
                      ),
                    ),
                  ),
                  projectProvider.projectDateBased.length > 0
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: MapDetails(
                            project: projectProvider.projectDateBased,
                          ))
                      : SizedBox(),
                  Expanded(
                    child: MapScreen(
                      projects: projectProvider.projectDateBased,
                    ),
                  )
                ],
              ),
            )),
        AdaptiveItem(
          height: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * .5,
          content: projectProvider.projectDateBased.length <= 0
              ? Expanded(
                  child: Container(
                    color: Palette.contentBackground,
                    child: EmtyList(
                      addingFunc: ProjectAddScreen(),
                      title: "No projects yet",
                      description:
                          "Its time to create a project \n choose the right client and location for your project",
                      buttonText: "Créer",
                      showButton: true,
                    ),
                  ),
                )
              : Container(
                  color: Palette.contentBackground,
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(
                      itemCount: projectProvider.projectDateBased.length,
                      itemBuilder: (context, index) {
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
                        );
                      }),
                ),
        )
      ]);
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Palette.drawerColor),
        ),
      );
    }
  }
}
