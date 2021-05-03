import 'dart:html';
import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/widgets/map.dart';

class ProjectAddScreen extends StatefulWidget {
  final ProjectModel? projectToEdit;
  const ProjectAddScreen({Key? key, this.projectToEdit}) : super(key: key);

  @override
  _ProjectAddScreenState createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen> {
  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    Provider.of<CustomerService>(context, listen: false).fetchCustomers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProjectAddService projectAddService =
        Provider.of<ProjectAddService>(context);
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    CustomerService customerService = Provider.of<CustomerService>(context);

    double _zoom = 15.0;
    LatLng coordinates = LatLng(28.709106207008052, 77.09902385711672);
    Marker? projectArea;

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
                        "La description",
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
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date de fin",
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
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date de début",
                                  style: boldText,
                                ),
                                MaterialButton(
                                  onPressed: () => projectAddService
                                      .selectStartDate(context),
                                  child: Text(
                                      "${projectAddService.startDate.toLocal()}"
                                          .split(' ')[0]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                            "${Provider.of<MapService>(context).coordinates.latitude},${Provider.of<MapService>(context).coordinates.longitude}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
                    customerService.customers == null
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : customerService.customers.length == 0
                            ? Text("No client to assign")
                            : Container(
                                height: 60,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: customerService.customers.length,
                                    itemBuilder: (context, index) {
                                      return projectAddService
                                                  .activeOwnerIndex ==
                                              customerService
                                                  .customers[index].id
                                          ? GestureDetector(
                                              onTap: () {
                                                projectAddService.setOwner =
                                                    customerService
                                                        .customers[index].id;
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
                                                        customerService
                                                            .customers[index]
                                                            .fname,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                projectAddService.setOwner =
                                                    customerService
                                                        .customers[index].id;
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                height: 60,
                                                width: 150,
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(customerService
                                                        .customers[index]
                                                        .fname),
                                                  ),
                                                ),
                                              ));
                                    }),
                              ),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        "Employees to assign",
                        style: boldText,
                      ),
                    ),
                    employeeSevice.users == null
                        ? CircularProgressIndicator()
                        : employeeSevice.users.length == 0
                            ? Text("No employee to assign")
                            : Container(
                                height: 60,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: employeeSevice.users.length,
                                    itemBuilder: (context, index) {
                                      return projectAddService.assignee
                                              .contains(employeeSevice
                                                  .users[index].id)
                                          ? GestureDetector(
                                              onTap: () {
                                                projectAddService.removeAssigne(
                                                    employeeSevice
                                                        .users[index].id);
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
                                                        employeeSevice
                                                            .users[index].fname,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  )),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                projectAddService.asignUser(
                                                    employeeSevice
                                                        .users[index].id);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                height: 60,
                                                width: 150,
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(employeeSevice
                                                        .users[index].fname),
                                                  ),
                                                ),
                                              ));
                                    }),
                              )
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
                    projectToEdit: widget.projectToEdit,
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
