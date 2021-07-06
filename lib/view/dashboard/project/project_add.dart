import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project_add_service.dart';
import 'package:uitemplate/widgets/map.dart';

class ProjectAddScreen extends StatelessWidget {
  final ProjectModel? projectToEdit;

  const ProjectAddScreen({Key? key, this.projectToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProjectAddService projectAddService =
        Provider.of<ProjectAddService>(context);
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height,
        child: AdaptiveContainer(children: [
          AdaptiveItem(
            content: Container(
              padding: EdgeInsets.all(10),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: projectAddService.nameController,
                    decoration: InputDecoration(
                      hintText: "Nom du Chantier",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Container(
                    height: 5 * 24.0,
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: "Description",
                      ),
                      controller: projectAddService.descriptionController,
                    ),
                  ),

                  //list of users
                  Consumer<EmployeeSevice>(
                    builder: (_, data, child) {
                      return Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.users.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(data.users[index].fname),
                              );
                            }),
                      );
                    },
                  ),

                  Row(
                    children: [
                      Text("Start Date"),
                      SizedBox(
                        width: MySpacer.small,
                      ),
                      Text("${projectAddService.startDate.toLocal()}"
                          .split(' ')[0]),
                      MaterialButton(
                        onPressed: () =>
                            projectAddService.selectStartDate(context),
                        child: Text('Start date'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.medium,
                  ),
                  Row(
                    children: [
                      Text("End Date"),
                      SizedBox(
                        width: MySpacer.small,
                      ),
                      Text("${projectAddService.endDate.toLocal()}"
                          .split(' ')[0]),
                      MaterialButton(
                        onPressed: () =>
                            projectAddService.selectEndDate(context),
                        child: Text('End date'),
                      ),
                    ],
                  ),
                  Consumer<MapService>(
                    builder: (_, data, child) {
                      return Text("Location ${data.coordinates}");
                    },
                  ),

                  MaterialButton(
                    onPressed: () {
                      // SUBMIT
                    },
                    child: Text("Create Project"),
                  )
                ],
              )),
            ),
          ),
          AdaptiveItem(
              content: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.width,
                  width: double.infinity,
                  child: MapScreen())),
        ]));
  }
}
