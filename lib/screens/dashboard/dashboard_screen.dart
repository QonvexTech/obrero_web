import 'package:adaptive_container/adaptive_container.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/services/dashboard_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/project_service.dart';
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
    Provider.of<ProjectProvider>(context, listen: false).fetchProjects();
    Provider.of<CustomerService>(context, listen: false).fetchCustomers();
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      List<ProjectModel> projects =
          Provider.of<ProjectProvider>(context).projects;
      DashboardService dashboardService =
          Provider.of<DashboardService>(context);
      return AdaptiveContainer(children: [
        AdaptiveItem(
            height: MediaQuery.of(context).size.height,
            content: Container(
              color: Palette.contentBackground,
              child: Column(
                children: [
                  Container(
                    color: Palette.contentBackground,
                    padding: EdgeInsets.all(20),
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
                              initialSelectedDate: DateTime.now(),
                              selectionColor: Palette.drawerColor,
                              selectedTextColor: Colors.white,
                              locale: "fr_FR",
                              controller: dashboardService.dateController,
                              onDateChange: (date) {
                                //New Date
                              },
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
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: MapDetails()),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: MapScreen(),
                  ))
                ],
              ),
            )),
        AdaptiveItem(
          height: MediaQuery.of(context).size.width > 800
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * .10,
          content: Container(
            color: Palette.contentBackground,
            child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(
                    startDate: projects[index].startDate == null
                        ? DateTime.now()
                        : projects[index].startDate!,
                    name: projects[index].name!,
                    description: projects[index].description == null
                        ? ""
                        : projects[index].description!,
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
