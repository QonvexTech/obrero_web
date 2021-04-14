import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer_service.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.now();
    List<ProjectModel> projects =
        Provider.of<ProjectProvider>(context).projects;
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 800) {
        return Column(
          children: contents(1, projects, startDate),
        );
      } else {
        return Row(
          children: contents(2, projects, startDate),
        );
      }
    });
  }
}

List<Widget> contents(int myCrossAxis, List<ProjectModel> projects, startDate) {
  return [
    Expanded(
        child: Container(
      color: Palette.contentBackground,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            color: Palette.contentBackground,
            child: Card(
              child: DatePicker(
                startDate,
                initialSelectedDate: DateTime.now(),
                selectionColor: Palette.drawerColor,
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  // New date selected
                },
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MapDetails(
                myCrossAxis: myCrossAxis,
              )),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: MapScreen(),
              ))
        ],
      ),
    )),
    Expanded(
      child: Container(
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
  ];
}
