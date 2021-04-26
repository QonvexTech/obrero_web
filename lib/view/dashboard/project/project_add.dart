import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/widgets/map.dart';

class ProjectAddScreen extends StatelessWidget {
  final ProjectModel? projectToEdit;

  const ProjectAddScreen({Key? key, this.projectToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ProjectAddService projectAddService =
        Provider.of<ProjectAddService>(context);
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height - 300,
        child: Column(
          children: [
            Expanded(
              child: AdaptiveContainer(children: [
                AdaptiveItem(
                    content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        "Nom du Chantier",
                        style: boldText,
                      ),
                    ),
                    TextField(
                      controller: projectAddService.nameController,
                      decoration: InputDecoration(
                        hintText: "Nom du Chantier",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        "Description",
                        style: boldText,
                      ),
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

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "End Date",
                                style: boldText,
                              ),
                              MaterialButton(
                                onPressed: () =>
                                    projectAddService.selectEndDate(context),
                                child: Text(
                                    "${projectAddService.endDate.toLocal()}"
                                        .split(' ')[0]),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Start Date",
                                style: boldText,
                              ),
                              MaterialButton(
                                onPressed: () =>
                                    projectAddService.selectStartDate(context),
                                child: Text(
                                    "${projectAddService.startDate.toLocal()}"
                                        .split(' ')[0]),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location",
                                style: boldText,
                              ),
                              MaterialButton(
                                onPressed: () =>
                                    projectAddService.selectStartDate(context),
                                child: Text(
                                    "${Provider.of<MapService>(context).coordinates.latitude},${Provider.of<MapService>(context).coordinates.longitude}"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //list of users

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        "Client",
                        style: boldText,
                      ),
                    ),
                    Consumer<CustomerService>(
                      builder: (_, data, child) {
                        return Container(
                          height: 60,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.customers.length,
                              itemBuilder: (context, index) {
                                return projectAddService.activeOwnerIndex ==
                                        data.customers[index].id
                                    ? GestureDetector(
                                        onTap: () {
                                          projectAddService.setOwner =
                                              data.customers[index].id;
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(5),
                                            height: 60,
                                            width: 150,
                                            child: Card(
                                              color: Palette.drawerColor,
                                              margin: EdgeInsets.all(0),
                                              child: ListTile(
                                                title: Text(
                                                  data.customers[index].fname,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          projectAddService.setOwner =
                                              data.customers[index].id;
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 60,
                                          width: 150,
                                          child: Card(
                                            child: ListTile(
                                              title: Text(
                                                  data.customers[index].fname),
                                            ),
                                          ),
                                        ));
                              }),
                        );
                      },
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        "Employees to assign",
                        style: boldText,
                      ),
                    ),
                    Consumer<EmployeeSevice>(
                      builder: (_, data, child) {
                        return Container(
                          height: 60,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.users.length,
                              itemBuilder: (context, index) {
                                return projectAddService.assignee
                                        .contains(data.users[index].id)
                                    ? GestureDetector(
                                        onTap: () {
                                          projectAddService.removeAssigne(
                                              data.users[index].id);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(5),
                                            height: 60,
                                            width: 150,
                                            child: Card(
                                              color: Palette.drawerColor,
                                              margin: EdgeInsets.all(0),
                                              child: ListTile(
                                                title: Text(
                                                  data.users[index].fname,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          projectAddService
                                              .asignUser(data.users[index].id);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          height: 60,
                                          width: 150,
                                          child: Card(
                                            child: ListTile(
                                              title:
                                                  Text(data.users[index].fname),
                                            ),
                                          ),
                                        ));
                              }),
                        );
                      },
                    ),
                  ],
                )),
                AdaptiveItem(
                    content: Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.width > 800
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.width,
                        width: double.infinity,
                        child: MapScreen())),
              ]),
            ),
            SizedBox(
              height: MySpacer.medium,
            ),
            MaterialButton(
              height: 50,
              color: Palette.drawerColor,
              minWidth: double.infinity,
              onPressed: () {
                projectAddService.submit(
                    projectToEdit: projectToEdit,
                    projectService: projectProvider,
                    coordinates: Provider.of<MapService>(context, listen: false)
                        .coordinates,
                    context: context);
              },
              child: Text(
                "Create Project",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ));
  }
}
