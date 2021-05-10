import 'package:adaptive_container/adaptive_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/widgets/map.dart';

class ProjectAddScreen extends StatefulWidget {
  final ProjectModel? projectToEdit;
  const ProjectAddScreen({Key? key, this.projectToEdit}) : super(key: key);

  @override
  _ProjectAddScreenState createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen>
    with SettingsHelper {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    Provider.of<CustomerService>(context, listen: false).fetchCustomers();

    if (widget.projectToEdit != null) {
      var projectAddService =
          Provider.of<ProjectAddService>(context, listen: false);
      nameController.text = widget.projectToEdit!.name ?? "";
      descriptionController.text = widget.projectToEdit!.description ?? "";
      projectAddService.startDate = widget.projectToEdit!.startDate ?? "";
      projectAddService.endDate = widget.projectToEdit!.endDate ?? "";
      projectAddService.userToAssignIds(widget.projectToEdit!.assignees!);
      if (widget.projectToEdit!.owner!.id != null) {
        projectAddService.activeOwnerIndex = widget.projectToEdit!.owner!.id;
      }

      if (widget.projectToEdit!.address != null) {
        Provider.of<MapService>(context, listen: false).addressGeo =
            widget.projectToEdit!.address!;
      }

      if (widget.projectToEdit!.coordinates != null) {
        Provider.of<MapService>(context, listen: false).coordinates =
            widget.projectToEdit!.coordinates!;
      }

      isEdit = true;
    } else {
      // Provider.of<MapService>(context, listen: false).findLocalByCoordinates(
      //     widget.projectToEdit!.coordinates!.latitude.toString(),
      //     widget.projectToEdit!.coordinates!.longitude.toString());
    }

    Provider.of<ProjectAddService>(context, listen: false).bodyToEdit = {};
    print(Provider.of<ProjectAddService>(context, listen: false).bodyToEdit);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProjectAddService projectAddService =
        Provider.of<ProjectAddService>(context);
    ProjectProvider projectProvider = Provider.of<ProjectProvider>(context);
    EmployeeSevice employeeSevice = Provider.of<EmployeeSevice>(context);
    CustomerService customerService = Provider.of<CustomerService>(context);
    MapService mapService = Provider.of<MapService>(context);
    var _scrw = MediaQuery.of(context).size.width;
    var _scrh = MediaQuery.of(context).size.height;

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
                      onChanged: (value) {
                        projectAddService.addBodyEdit({"name": value});
                      },
                      controller: nameController,
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
                        onChanged: (value) {
                          projectAddService.addBodyEdit({"description": value});
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5)),
                          hintText: "Description",
                        ),
                        controller: descriptionController,
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
                                  onPressed: () => projectAddService
                                      .selectStartDate(context),
                                  child: Text(
                                      "${projectAddService.startDate.toLocal()}"
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
                                  onPressed: () =>
                                      projectAddService.selectEndDate(context),
                                  child: Text(
                                      "${projectAddService.endDate.toLocal()}"
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${Provider.of<MapService>(context).coordinates.latitude},${Provider.of<MapService>(context).coordinates.longitude}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MySpacer.small,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Address",
                          style: boldText,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "${Provider.of<MapService>(context).addressGeo}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    //CLIENTS
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        "Client",
                        style: boldText,
                      ),
                    ),
                    isEdit
                        ? Container(
                            margin: EdgeInsets.all(5),
                            height: 60,
                            width: 150,
                            child: Card(
                              color: Palette.drawerColor,
                              margin: EdgeInsets.all(0),
                              child: ListTile(
                                title: Text(
                                  widget.projectToEdit!.owner!.fname ??
                                      "No owner",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ))
                        : customerService.customers == null
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
                                        itemCount:
                                            customerService.customers.length,
                                        itemBuilder: (context, index) {
                                          return projectAddService
                                                      .activeOwnerIndex ==
                                                  customerService
                                                      .customers[index].id
                                              ? GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      height: 60,
                                                      width: 150,
                                                      child: Card(
                                                        color:
                                                            Palette.drawerColor,
                                                        margin:
                                                            EdgeInsets.all(0),
                                                        child: ListTile(
                                                          title: Text(
                                                            customerService
                                                                .customers[
                                                                    index]
                                                                .fname,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        "tapping ${customerService.customers[index].id}");
                                                    setState(() {
                                                      projectAddService
                                                          .setOwner(
                                                              customerService
                                                                  .customers[
                                                                      index]
                                                                  .id,
                                                              isEdit);

                                                      print(customerService
                                                          .customers[index].id);
                                                    });
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(5),
                                                    height: 60,
                                                    width: 150,
                                                    child: Card(
                                                      child: ListTile(
                                                        title: Text(
                                                            customerService
                                                                .customers[
                                                                    index]
                                                                .fname),
                                                      ),
                                                    ),
                                                  ));
                                        }),
                                  ),
                    //  EMPLOYEES
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: MySpacer.small),
                      child: Text(
                        isEdit ? "Assigned Employees" : "Employees to assign",
                        style: boldText,
                      ),
                    ),
                    employeeSevice.users == null
                        ? CircularProgressIndicator()
                        : employeeSevice.users!.length == 0
                            ? Text("No employee to assign")
                            : Container(
                                height: 60,
                                width: double.infinity,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: employeeSevice.users!.length,
                                    itemBuilder: (context, index) {
                                      return projectAddService.assignIds
                                              .contains(employeeSevice
                                                  .users![index].id)
                                          ? GestureDetector(
                                              onTap: () {
                                                projectAddService.removeAssigne(
                                                    employeeSevice
                                                        .users![index].id!);
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
                                                            .users![index]
                                                            .fname!,
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
                                                        .users![index].id!);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(5),
                                                height: 60,
                                                width: 150,
                                                child: Card(
                                                  child: ListTile(
                                                    title: Text(employeeSevice
                                                        .users![index].fname!),
                                                  ),
                                                ),
                                              ));
                                    }),
                              ),
                    SizedBox(
                      height: MySpacer.small,
                    ),
                    Text(
                      "Area Size",
                      style: boldText,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("${projectAddService.areaSize}m"),
                    Stack(
                      children: [
                        Container(
                          height: 60,
                          child: Slider(
                              value: projectAddService.areaSize,
                              max: 1000,
                              divisions: 50,
                              onChangeStart: (value) {
                                projectAddService.addBodyEdit(
                                    {"area_size": value.toString()});
                              },
                              onChanged: (newValue) {
                                projectAddService.areaSize = newValue;
                              }),
                        ),
                        Positioned(
                            bottom: 2,
                            right: 15,
                            child: Text(
                              "1000m",
                              style: TextStyle(color: Colors.blue[200]),
                            )),
                        Positioned(
                            bottom: 2,
                            left: 15,
                            child: Row(
                              children: [
                                Text("0m",
                                    style: TextStyle(color: Colors.blue[200])),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //PICTURES
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: MaterialButton(
                            onPressed: () async {
                              await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  allowedExtensions: [
                                    'jpg',
                                    'jpeg',
                                    'png'
                                  ]).then((pickedFile) {
                                projectAddService.addPicture(pickedFile);
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Upload Image",
                                    style: boldText,
                                  ),
                                  Icon(Icons.add_circle)
                                ],
                              ),
                            ))),

                    Container(
                      width: _scrw,
                      height: _scrh * .3,
                      child: GridView.count(
                        crossAxisCount: 3,
                        children: [
                          for (var image in projectAddService.projectImages)
                            Container(
                              width: _scrh * .26,
                              height: _scrh * .26,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: Offset(3, 3),
                                      blurRadius: 2,
                                    )
                                  ],
                                  image: DecorationImage(
                                      fit: profileData?.picture == null &&
                                              image == null
                                          ? BoxFit.scaleDown
                                          : BoxFit.cover,
                                      alignment: profileData?.picture == null &&
                                              image == null
                                          ? AlignmentDirectional.bottomCenter
                                          : AlignmentDirectional.center,
                                      image: tempImageProvider(
                                          file: image,
                                          netWorkImage: profileData?.picture,
                                          defaultImage: 'icons/admin_icon.png'),
                                      scale: profileData?.picture == null
                                          ? 5
                                          : 1)),
                            ),
                          if (projectAddService.projectImages.length == 0)
                            Container(
                              width: _scrw,
                              height: _scrh * 0.15,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/emptyImage.jpg"))),
                            ),
                        ],
                      ),
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
            Row(
              children: [
                Expanded(
                  child: MaterialButton(
                    height: 50,
                    color: Colors.grey[200],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Annuler",
                        style: TextStyle(color: Colors.black45)),
                  ),
                ),
                SizedBox(
                  width: MySpacer.medium,
                ),
                Expanded(
                  flex: 3,
                  child: MaterialButton(
                    height: 50,
                    color: Palette.drawerColor,
                    minWidth: double.infinity,
                    onPressed: () {
                      if (isEdit) {
                        projectAddService.addBodyEdit({
                          "project_id": widget.projectToEdit!.id.toString()
                        });
                        // projectAddService
                        //     .addBodyEdit({"address": mapService.addressGeo});

                        if (projectAddService.assignIdsToAdd.length > 0) {
                          print("ADDING");
                          projectAddService
                              .assign(
                                  listAssignIds: projectAddService
                                      .assignIdsToAdd
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                                  projectId: widget.projectToEdit!.id!)
                              .whenComplete(
                                  () => projectProvider.fetchProjects());
                        }
                        if (projectAddService.assignIdsToRemove.length > 0) {
                          print("REMOVING");
                          projectAddService
                              .removeAssign(
                                  listAssignIds: projectAddService
                                      .assignIdsToRemove
                                      .toString()
                                      .replaceAll("[", "")
                                      .replaceAll("]", ""),
                                  projectId: widget.projectToEdit!.id!)
                              .whenComplete(
                                  () => projectProvider.fetchProjects());
                        }

                        projectProvider.updateProject(
                            bodyToEdit: projectAddService.bodyToEdit);

                        Navigator.pop(context);
                      } else {
                        ProjectModel newProject = ProjectModel(
                            assigneeIds: projectAddService.assignIds,
                            customerId: projectAddService.activeOwnerIndex,
                            description: descriptionController.text,
                            name: nameController.text,
                            coordinates: mapService.coordinates,
                            picture: projectAddService.converteduint8list(),
                            startDate: projectAddService.startDate,
                            endDate: projectAddService.endDate,
                            address: mapService.addressGeo,
                            areaSize: projectAddService.areaSize);

                        projectProvider
                            .createProjects(
                              newProject: newProject,
                            )
                            .whenComplete(() => Navigator.pop(context));
                      }
                    },
                    child: Text(
                      isEdit ? "Mettre à jour" : "Créer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
