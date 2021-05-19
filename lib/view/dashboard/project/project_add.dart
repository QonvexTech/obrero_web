import 'package:adaptive_container/adaptive_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
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
  const ProjectAddScreen({
    Key? key,
    this.projectToEdit,
  }) : super(key: key);

  @override
  _ProjectAddScreenState createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen>
    with SettingsHelper {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool isEdit = false;
  bool checked = false;
  CustomerModel? customerSelected;

  bool hovering = false;

  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).initLoad();
    Provider.of<CustomerService>(context, listen: false).initLoad();

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
              child: AdaptiveContainer(
                  physics:
                      ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  children: [
                    AdaptiveItem(
                      height: MediaQuery.of(context).size.height,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediaQuery.of(context).size.width < 1200
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: double.infinity,
                                  child: MapScreen(
                                    setCoord: true,
                                  ))
                              : SizedBox(),
                          Expanded(
                            child: ListView(
                              physics: hovering
                                  ? NeverScrollableScrollPhysics()
                                  : AlwaysScrollableScrollPhysics(),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: MySpacer.small),
                                  child: Text(
                                    "Nom du Chantier",
                                    style: boldText,
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) {
                                    projectAddService
                                        .addBodyEdit({"name": value});
                                  },
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: "Nom du Chantier",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: MySpacer.small),
                                  child: Text(
                                    "La description",
                                    style: boldText,
                                  ),
                                ),
                                Container(
                                  height: 5 * 24.0,
                                  child: TextField(
                                    onChanged: (value) {
                                      projectAddService
                                          .addBodyEdit({"description": value});
                                    },
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      hintText: "Description",
                                    ),
                                    controller: descriptionController,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: MySpacer.small),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Date de fin",
                                              style: boldText,
                                            ),
                                            MaterialButton(
                                              onPressed: () => projectAddService
                                                  .selectEndDate(context),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: TextField(
                                          controller: mapService.location,
                                        )),
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
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: TextField(
                                          controller: mapService.address,
                                        )),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        "Cliente",
                                        style: boldText,
                                      ),
                                    ),
                                    customerSelected != null
                                        ? Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(5),
                                                height: 60,
                                                width: 200,
                                                child: Card(
                                                  color: Palette.drawerColor,
                                                  child: Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          maxRadius: 15,
                                                          backgroundImage: fetchImage(
                                                              netWorkImage:
                                                                  customerSelected!
                                                                      .picture),
                                                        ),
                                                        SizedBox(
                                                          width: MySpacer.small,
                                                        ),
                                                        Text(
                                                          "${customerSelected!.fname!} ${customerSelected!.lname!}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ),
                                              ),
                                              _customPopupItemBuilderExample(
                                                  context,
                                                  Icon(Icons.loop),
                                                  customerService,
                                                  projectAddService),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                  width: 200,
                                                  height: 60,
                                                  child:
                                                      _customPopupItemBuilderExample(
                                                          context,
                                                          DottedBorder(
                                                              child: Container(
                                                            height: 60,
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    "Attribuer un client",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  SizedBox(
                                                                    width: MySpacer
                                                                        .small,
                                                                  ),
                                                                  Icon(Icons
                                                                      .add_circle)
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                          customerService,
                                                          projectAddService)),
                                            ],
                                          ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: MySpacer.small),
                                  child: Text(
                                    isEdit
                                        ? "Employés affectés"
                                        : "Affecter des employés",
                                    style: boldText,
                                  ),
                                ),
                                employeeSevice.userload == null
                                    ? Center(child: CircularProgressIndicator())
                                    : employeeSevice.userload!.length == 0
                                        ? Text("No employee to assign")
                                        : Container(
                                            height: 60,
                                            width: double.infinity,
                                            child: LazyLoadScrollView(
                                              scrollDirection: Axis.horizontal,
                                              onEndOfPage: () {
                                                employeeSevice.loadMore();
                                              },
                                              child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: employeeSevice
                                                      .userload!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return projectAddService
                                                            .assignIds
                                                            .contains(
                                                                employeeSevice
                                                                    .userload![
                                                                        index]
                                                                    .id)
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              projectAddService
                                                                  .removeAssigne(
                                                                      employeeSevice
                                                                          .userload![
                                                                              index]
                                                                          .id!);
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              height: 60,
                                                              width: 200,
                                                              child: Card(
                                                                color: Palette
                                                                    .drawerColor,
                                                                child: Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        maxRadius:
                                                                            15,
                                                                        backgroundImage:
                                                                            fetchImage(netWorkImage: employeeSevice.userload![index].picture),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MySpacer
                                                                            .small,
                                                                      ),
                                                                      Text(
                                                                        "${employeeSevice.userload![index].fname!} ${employeeSevice.userload![index].lname!}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                              ),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              projectAddService.asignUser(
                                                                  employeeSevice
                                                                      .userload![
                                                                          index]
                                                                      .id!);
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              height: 60,
                                                              width: 200,
                                                              child: Card(
                                                                child: Center(
                                                                    child:
                                                                        Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor:
                                                                            Colors.transparent,
                                                                        maxRadius:
                                                                            15,
                                                                        backgroundImage:
                                                                            fetchImage(netWorkImage: employeeSevice.userload![index].picture),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MySpacer
                                                                            .small,
                                                                      ),
                                                                      Text(
                                                                        "${employeeSevice.userload![index].fname!} ${employeeSevice.userload![index].lname!}",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )),
                                                              ),
                                                            ));
                                                  }),
                                            ),
                                          ),
                                SizedBox(
                                  height: MySpacer.small,
                                ),
                                Text(
                                  "Taille de la zone",
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
                                            projectAddService.addBodyEdit({
                                              "area_size": value.toString()
                                            });
                                          },
                                          onChanged: (newValue) {
                                            projectAddService.areaSize =
                                                newValue;
                                          }),
                                    ),
                                    Positioned(
                                        bottom: 2,
                                        right: 15,
                                        child: Text(
                                          "1000m",
                                          style: TextStyle(
                                              color: Colors.blue[200]),
                                        )),
                                    Positioned(
                                        bottom: 2,
                                        left: 15,
                                        child: Row(
                                          children: [
                                            Text("0m",
                                                style: TextStyle(
                                                    color: Colors.blue[200])),
                                          ],
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                //PICTURES
                                projectAddService.projectImages.length <= 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Photos",
                                            style: boldText,
                                          ),
                                          SizedBox(height: MySpacer.small),
                                          MaterialButton(
                                            onPressed: () async {
                                              await FilePicker.platform
                                                  .pickFiles(
                                                      allowMultiple: false,
                                                      allowedExtensions: [
                                                    'jpg',
                                                    'jpeg',
                                                    'png'
                                                  ]).then((pickedFile) {
                                                projectAddService
                                                    .addPicture(pickedFile);
                                              });
                                            },
                                            child: DottedBorder(
                                              color: Colors.black12,
                                              strokeWidth: 2,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                                  allowMultiple:
                                                                      true,
                                                                  allowedExtensions: [
                                                                'jpg',
                                                                'jpeg',
                                                                'png'
                                                              ]).then(
                                                                  (pickedFile) {
                                                            print(pickedFile);
                                                            projectAddService
                                                                .addPicture(
                                                                    pickedFile);
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.upload_rounded,
                                                          color: Palette
                                                              .drawerColor,
                                                        ),
                                                      ),
                                                      Text("Upload Image")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          MaterialButton(
                                              onPressed: () async {
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        allowMultiple: false,
                                                        allowedExtensions: [
                                                      'jpg',
                                                      'jpeg',
                                                      'png'
                                                    ]).then((pickedFile) {
                                                  projectAddService
                                                      .addPicture(pickedFile);
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text("Add More"),
                                                  SizedBox(
                                                    width: MySpacer.small,
                                                  ),
                                                  Icon(Icons.add_circle),
                                                ],
                                              )),
                                          Container(
                                            width: _scrw,
                                            height: _scrh * .3,
                                            child: GridView.count(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 5,
                                              children: [
                                                for (var image
                                                    in projectAddService
                                                        .projectImages)
                                                  Container(
                                                    width: _scrh * .26,
                                                    height: _scrh * .26,
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade100,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .grey.shade400,
                                                            offset:
                                                                Offset(3, 3),
                                                            blurRadius: 2,
                                                          )
                                                        ],
                                                        image: DecorationImage(
                                                            fit: profileData?.picture ==
                                                                        null &&
                                                                    image ==
                                                                        null
                                                                ? BoxFit
                                                                    .scaleDown
                                                                : BoxFit.cover,
                                                            alignment: profileData
                                                                            ?.picture ==
                                                                        null &&
                                                                    image ==
                                                                        null
                                                                ? AlignmentDirectional
                                                                    .bottomCenter
                                                                : AlignmentDirectional
                                                                    .center,
                                                            image: tempImageProvider(
                                                                file: image,
                                                                netWorkImage:
                                                                    profileData
                                                                        ?.picture,
                                                                defaultImage:
                                                                    'icons/admin_icon.png'),
                                                            scale: profileData
                                                                        ?.picture ==
                                                                    null
                                                                ? 5
                                                                : 1)),
                                                  ),
                                                if (projectAddService
                                                        .projectImages.length ==
                                                    0)
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
                                      ),
                                SizedBox(
                                  height: 500,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    AdaptiveItem(
                        content: Container(
                            padding: EdgeInsets.all(20),
                            height: MediaQuery.of(context).size.width > 800
                                ? MediaQuery.of(context).size.height
                                : MediaQuery.of(context).size.width,
                            width: double.infinity,
                            child: MapScreen(
                              setCoord: true,
                            ))),
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
                            address: mapService.address.text,
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

  Widget _customPopupItemBuilderExample(BuildContext context, child,
      CustomerService customerService, ProjectAddService projectAddService) {
    ScrollController? controller;

    return PopupMenuButton(
        tooltip: "Montrer aux clients",
        offset: Offset(0, 0),
        icon: child,
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Consumer<CustomerService>(
                  builder: (context, data, child) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Center(
                        child: LazyLoadScrollView(
                          onEndOfPage: () {
                            customerService.loadMore();
                          },
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[800]),
                                      hintText: "Rechercher",
                                      fillColor: Colors.white70),
                                  onChanged: (text) {
                                    customerService.searchLoad(text);
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  controller: controller,
                                  itemCount:
                                      customerService.customersLoad.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          customerSelected = customerService
                                              .customersLoad[index];
                                          projectAddService.activeOwnerIndex =
                                              customerService
                                                  .customersLoad[index].id;
                                          customerService.searchLoad("");
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 200,
                                        child: Card(
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Palette.contentBackground,
                                                  maxRadius: 15,
                                                  backgroundImage: fetchImage(
                                                      netWorkImage:
                                                          customerService
                                                              .customersLoad[
                                                                  index]
                                                              .picture),
                                                ),
                                                SizedBox(
                                                  width: MySpacer.small,
                                                ),
                                                Text(
                                                  "${customerService.customersLoad[index].fname!} ${customerService.customersLoad[index].lname!}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]);
  }
}
