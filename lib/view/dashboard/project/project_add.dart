import 'package:adaptive_container/adaptive_container.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/color_model.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_add_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/widgets/map.dart';

//TODO: add more status colors;
class ProjectAddScreen extends StatefulWidget {
  final ProjectModel? projectToEdit;

  final CustomerModel? customer;

  const ProjectAddScreen({Key? key, this.projectToEdit, this.customer})
      : super(key: key);

  @override
  _ProjectAddScreenState createState() => _ProjectAddScreenState();
}

class _ProjectAddScreenState extends State<ProjectAddScreen>
    with SettingsHelper {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  final _nom = FocusNode();
  final _desc = FocusNode();

  final _startDate = FocusNode();
  final _endDate = FocusNode();
  final _address = FocusNode();
  final _delete = FocusNode();
  final _submit = FocusNode();
  final _cancel = FocusNode();

  ColorModels? selectedStatus;

  final _formKey = GlobalKey<FormState>();
  bool isEdit = false;
  bool checked = false;
  bool loader = false;

  CustomerModel? customerSelected;

  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).initLoad();
    Provider.of<CustomerService>(context, listen: false).initLoad();

    selectedStatus = colorsSettings[0];

    if (widget.customer != null) {
      customerSelected = widget.customer;
    }

    Provider.of<ProjectAddService>(context, listen: false).assignIds.clear();
    Provider.of<MapService>(context, listen: false).circles.clear();

    if (widget.projectToEdit != null) {
      Provider.of<ProjectAddService>(context, listen: false);
      nameController.text = widget.projectToEdit!.name ?? "";
      descriptionController.text = widget.projectToEdit!.description ?? "";
      Provider.of<ProjectAddService>(context, listen: false).startDate =
          widget.projectToEdit!.startDate ?? "";
      Provider.of<ProjectAddService>(context, listen: false).endDate =
          widget.projectToEdit!.endDate ?? "";

      print("image length ${widget.projectToEdit!.images!.length}");

      Provider.of<ProjectAddService>(context, listen: false)
          .userToAssignIds(widget.projectToEdit!.assignees!);
      if (widget.projectToEdit!.owner!.id != null) {
        Provider.of<ProjectAddService>(context, listen: false)
            .activeOwnerIndex = widget.projectToEdit!.owner!.id;
      }

      if (widget.projectToEdit!.address != null) {
        Provider.of<MapService>(context, listen: false).addressGeo =
            widget.projectToEdit!.address!;
        Provider.of<MapService>(context, listen: false).address.text =
            widget.projectToEdit!.address!;
      }

      Provider.of<MapService>(context, listen: false).coordinates =
          widget.projectToEdit!.coordinates!;
      setState(() {
        initialPositon = widget.projectToEdit!.coordinates!;
      });

      if (widget.projectToEdit!.owner != null) {
        customerSelected = widget.projectToEdit!.owner;
      }

      isEdit = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();

    _nom.dispose();
    _desc.dispose();
    _address.dispose();
    _startDate.dispose();
    _endDate.dispose();
    _delete.dispose();
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
        child: loader == true
            ? Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator()),
                    SizedBox(
                      width: MySpacer.small,
                    ),
                    Text("Creating Project...")
                  ],
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: AdaptiveContainer(
                          physics: ScrollPhysics(
                              parent: NeverScrollableScrollPhysics()),
                          children: [
                            AdaptiveItem(
                              height: MediaQuery.of(context).size.height,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MediaQuery.of(context).size.width < 1200
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: double.infinity,
                                          child: MapScreen(
                                            setCoord: true,
                                            onCreate: () {},
                                            areaSize:
                                                projectAddService.areaSize,
                                          ))
                                      : SizedBox(),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: MySpacer.small),
                                          child: Text(
                                            "Nom du Chantier",
                                            style: boldText,
                                          ),
                                        ),
                                        RawKeyboardListener(
                                          onKey: (x) {
                                            if (x.isKeyPressed(
                                                LogicalKeyboardKey.tab)) {}
                                          },
                                          focusNode: _nom,
                                          child: TextFormField(
                                            autofocus: true,
                                            onChanged: (value) {
                                              projectAddService
                                                  .addBodyEdit({"name": value});
                                            },
                                            onFieldSubmitted: (z) {
                                              _desc.requestFocus();
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Nom obligatoire!';
                                              }
                                            },
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              hintText: "Nom du Chantier",
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
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
                                        RawKeyboardListener(
                                          focusNode: _desc,
                                          onKey: (y) {
                                            if (y.isKeyPressed(
                                                LogicalKeyboardKey.tab)) {
                                              _address.requestFocus();
                                            }
                                          },
                                          child: TextFormField(
                                            onFieldSubmitted: (z) {
                                              _address.requestFocus();
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'La description obligatoire!';
                                              }
                                            },
                                            onChanged: (value) {
                                              projectAddService.addBodyEdit(
                                                  {"description": value});
                                            },
                                            maxLines: 5,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              hintText: "La description",
                                            ),
                                            controller: descriptionController,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Adresse",
                                              style: boldText,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: RawKeyboardListener(
                                                  focusNode: _address,
                                                  onKey: (x) {
                                                    if (x.isKeyPressed(
                                                        LogicalKeyboardKey
                                                            .tab)) {
                                                      _address.requestFocus();
                                                    }
                                                  },
                                                  child: TextField(
                                                    controller:
                                                        mapService.address,
                                                  ),
                                                )),
                                          ],
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
                                                      focusNode: _startDate,
                                                      enableFeedback: false,
                                                      onPressed: () =>
                                                          projectAddService
                                                              .selectStartDate(
                                                                  context),
                                                      child: Text(
                                                          "${months[projectAddService.startDate.month]} ${projectAddService.startDate.day}, ${DateFormat.y().format(projectAddService.startDate)}"),
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
                                                      enableFeedback: false,
                                                      focusNode: _endDate,
                                                      onPressed: () =>
                                                          projectAddService
                                                              .selectEndDate(
                                                                  context),
                                                      child: Text(
                                                          "${months[projectAddService.endDate.month]} ${projectAddService.endDate.day}, ${DateFormat.y().format(projectAddService.endDate)}"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment.start,
                                        //   children: [
                                        //     Text(
                                        //       "Status",
                                        //       style: boldText,
                                        //     ),
                                        //     Container(
                                        //       height: 60,
                                        //       child: ListView(
                                        //         scrollDirection:
                                        //             Axis.horizontal,
                                        //         children: [
                                        //           for (var color
                                        //               in colorsSettings)
                                        //             color == selectedStatus
                                        //                 ? GestureDetector(
                                        //                     onTap: () {},
                                        //                     child: Container(
                                        //                       margin: EdgeInsets
                                        //                           .all(5),
                                        //                       height: 60,
                                        //                       width: 200,
                                        //                       child: Card(
                                        //                         color: Palette
                                        //                             .drawerColor,
                                        //                         child: Center(
                                        //                             child:
                                        //                                 Padding(
                                        //                           padding:
                                        //                               const EdgeInsets
                                        //                                       .all(
                                        //                                   8.0),
                                        //                           child: Row(
                                        //                             children: [
                                        //                               Icon(
                                        //                                 Icons
                                        //                                     .circle,
                                        //                                 color: color
                                        //                                     .color,
                                        //                               ),
                                        //                               SizedBox(
                                        //                                 width: MySpacer
                                        //                                     .small,
                                        //                               ),
                                        //                               Flexible(
                                        //                                 child:
                                        //                                     Text(
                                        //                                   "${color.name}",
                                        //                                   style: TextStyle(
                                        //                                       fontSize: 13,
                                        //                                       color: Colors.white),
                                        //                                   overflow:
                                        //                                       TextOverflow.ellipsis,
                                        //                                 ),
                                        //                               ),
                                        //                             ],
                                        //                           ),
                                        //                         )),
                                        //                       ),
                                        //                     ),
                                        //                   )
                                        //                 : GestureDetector(
                                        //                     onTap: () {
                                        //                       setState(() {
                                        //                         selectedStatus =
                                        //                             color;

                                        //                         mapService
                                        //                             .setStatus(colorsSettings.indexOf(selectedStatus!));
                                        //                       });
                                        //                     },
                                        //                     child: Container(
                                        //                       margin: EdgeInsets
                                        //                           .all(5),
                                        //                       height: 60,
                                        //                       width: 200,
                                        //                       child: Card(
                                        //                         child: Center(
                                        //                             child:
                                        //                                 Padding(
                                        //                           padding:
                                        //                               const EdgeInsets
                                        //                                       .all(
                                        //                                   8.0),
                                        //                           child: Row(
                                        //                             children: [
                                        //                               Icon(
                                        //                                 Icons
                                        //                                     .circle,
                                        //                                 color: color
                                        //                                     .color,
                                        //                               ),
                                        //                               SizedBox(
                                        //                                 width: MySpacer
                                        //                                     .small,
                                        //                               ),
                                        //                               Flexible(
                                        //                                 child:
                                        //                                     Text(
                                        //                                   "${color.name}",
                                        //                                   style: TextStyle(
                                        //                                       fontSize: 13,
                                        //                                       color: Colors.black),
                                        //                                   overflow:
                                        //                                       TextOverflow.ellipsis,
                                        //                                 ),
                                        //                               ),
                                        //                             ],
                                        //                           ),
                                        //                         )),
                                        //                       ),
                                        //                     ),
                                        //                   )
                                        //         ],
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),

                                        isEdit
                                            ? SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
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
                                                                            fetchImage(netWorkImage: customerSelected!.picture),
                                                                      ),
                                                                      SizedBox(
                                                                        width: MySpacer
                                                                            .small,
                                                                      ),
                                                                      Text(
                                                                        "${customerSelected!.fname!} ${customerSelected!.lname!}",
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
                                                            _customPopupItemBuilderExample(
                                                                context,
                                                                Icon(
                                                                    Icons.loop),
                                                                customerService,
                                                                projectAddService),
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            Container(
                                                                width: 200,
                                                                height: 60,
                                                                child: _customPopupItemBuilderExample(
                                                                    context,
                                                                    DottedBorder(
                                                                        child: Container(
                                                                      height:
                                                                          60,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Attribuer un client",
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            SizedBox(
                                                                              width: MySpacer.small,
                                                                            ),
                                                                            Icon(Icons.add_circle)
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
                                                : "Employés assignés",
                                            style: boldText,
                                          ),
                                        ),
                                        Container(
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
                                                itemBuilder: (context, index) {
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
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
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
                                                                          Colors
                                                                              .transparent,
                                                                      maxRadius:
                                                                          15,
                                                                      backgroundImage: fetchImage(
                                                                          netWorkImage: employeeSevice
                                                                              .userload![index]
                                                                              .picture),
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
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                            ),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            projectAddService
                                                                .asignUser(
                                                                    employeeSevice
                                                                        .userload![
                                                                            index]
                                                                        .id!);
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
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
                                                                          Colors
                                                                              .transparent,
                                                                      maxRadius:
                                                                          15,
                                                                      backgroundImage: fetchImage(
                                                                          netWorkImage: employeeSevice
                                                                              .userload![index]
                                                                              .picture),
                                                                    ),
                                                                    SizedBox(
                                                                      width: MySpacer
                                                                          .small,
                                                                    ),
                                                                    Text(
                                                                      "${employeeSevice.userload![index].fname!} ${employeeSevice.userload![index].lname!}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
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
                                          "Surface",
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
                                                  autofocus: false,
                                                  value: projectAddService
                                                      .areaSize,
                                                  max: 1000,
                                                  divisions: 50,
                                                  onChangeStart: (value) {
                                                    setState(() {
                                                      projectAddService
                                                          .addBodyEdit({
                                                        "area_size":
                                                            value.toString()
                                                      });
                                                    });
                                                  },
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      projectAddService
                                                          .areaSize = newValue;

                                                      projectAddService
                                                          .addBodyEdit({
                                                        "area_size":
                                                            newValue.toString()
                                                      });

                                                      mapService.changeAreaSize(
                                                          newValue,
                                                          Provider.of<MapService>(
                                                                  context,
                                                                  listen: false)
                                                              .coordinates);
                                                    });
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
                                                            color: Colors
                                                                .blue[200])),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        // PICTURES
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Photos",
                                              style: boldText,
                                            ),
                                            SizedBox(height: MySpacer.small),
                                            MaterialButton(
                                              focusNode: null,
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
                                                          focusNode: null,
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
                                                            Icons
                                                                .upload_rounded,
                                                            color: Palette
                                                                .drawerColor,
                                                          ),
                                                        ),
                                                        Text("Importer image"),
                                                        SizedBox(
                                                          height:
                                                              MySpacer.small,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        widget.projectToEdit != null
                                            ? SizedBox(
                                                height: MySpacer.medium,
                                              )
                                            : SizedBox(),

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            widget.projectToEdit == null
                                                ? Container(
                                                    width: _scrw,
                                                    height: projectAddService
                                                                .projectImages
                                                                .length >
                                                            0
                                                        ? _scrh * .3
                                                        : 0,
                                                    child: GridView.count(
                                                      crossAxisCount: 3,
                                                      mainAxisSpacing: 5,
                                                      crossAxisSpacing: 5,
                                                      children: [
                                                        for (var image
                                                            in projectAddService
                                                                .projectImages)
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    _scrh * .26,
                                                                height:
                                                                    _scrh * .26,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade100,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.shade400,
                                                                            offset:
                                                                                Offset(3, 3),
                                                                            blurRadius:
                                                                                2,
                                                                          )
                                                                        ],
                                                                        image: DecorationImage(
                                                                            fit: profileData?.picture == null && image == null
                                                                                ? BoxFit.scaleDown
                                                                                : BoxFit.cover,
                                                                            alignment: profileData?.picture == null && image == null ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
                                                                            image: tempImageProvider(file: image, netWorkImage: profileData?.picture, defaultImage: 'icons/admin_icon.png'),
                                                                            scale: profileData?.picture == null ? 5 : 1)),
                                                              ),
                                                              Positioned(
                                                                top: 5,
                                                                right: 5,
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .white38),
                                                                  child: IconButton(
                                                                      focusNode: _delete,
                                                                      icon: Icon(
                                                                        Icons
                                                                            .delete_forever,
                                                                        color: Colors
                                                                            .red[600],
                                                                      ),
                                                                      onPressed: () {
                                                                        projectAddService
                                                                            .removeImage(image);
                                                                      }),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    width: _scrw,
                                                    height: _scrh * .3,
                                                    child: GridView.count(
                                                      crossAxisCount: 3,
                                                      mainAxisSpacing: 5,
                                                      crossAxisSpacing: 5,
                                                      children: [
                                                        for (var image in widget
                                                            .projectToEdit!
                                                            .images!) ...{
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                  width: _scrh *
                                                                      .26,
                                                                  height:
                                                                      _scrh *
                                                                          .26,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade100,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade400,
                                                                        offset: Offset(
                                                                            3,
                                                                            3),
                                                                        blurRadius:
                                                                            2,
                                                                      )
                                                                    ],
                                                                    image: DecorationImage(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: tempImageProvider(
                                                                            netWorkImage:
                                                                                image.url,
                                                                            defaultImage: "images/emptyImage.jpg")),
                                                                  )),
                                                              Positioned(
                                                                top: 5,
                                                                right: 5,
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .white38),
                                                                  child: IconButton(
                                                                      focusNode: _delete,
                                                                      icon: Icon(
                                                                        Icons
                                                                            .delete_forever,
                                                                        color: Colors
                                                                            .red[600],
                                                                      ),
                                                                      onPressed: () {
                                                                        projectAddService
                                                                            .addImageToDelete(image);

                                                                        widget
                                                                            .projectToEdit!
                                                                            .images!
                                                                            .remove(image);
                                                                      }),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        },
                                                        for (var image
                                                            in projectAddService
                                                                .projectImages)
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    _scrh * .26,
                                                                height:
                                                                    _scrh * .26,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade100,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey.shade400,
                                                                            offset:
                                                                                Offset(3, 3),
                                                                            blurRadius:
                                                                                2,
                                                                          )
                                                                        ],
                                                                        image: DecorationImage(
                                                                            fit: profileData?.picture == null && image == null
                                                                                ? BoxFit.scaleDown
                                                                                : BoxFit.cover,
                                                                            alignment: profileData?.picture == null && image == null ? AlignmentDirectional.bottomCenter : AlignmentDirectional.center,
                                                                            image: tempImageProvider(file: image, netWorkImage: profileData?.picture, defaultImage: 'icons/admin_icon.png'),
                                                                            scale: profileData?.picture == null ? 5 : 1)),
                                                              ),
                                                              Positioned(
                                                                top: 5,
                                                                right: 5,
                                                                child:
                                                                    AnimatedContainer(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          300),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .white38),
                                                                  child: IconButton(
                                                                      focusNode: _delete,
                                                                      icon: Icon(
                                                                        Icons
                                                                            .delete_forever,
                                                                        color: Colors
                                                                            .red[600],
                                                                      ),
                                                                      onPressed: () {
                                                                        projectAddService
                                                                            .removeImage(image);
                                                                      }),
                                                                ),
                                                              )
                                                            ],
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
                                    padding: EdgeInsets.only(top: 20, left: 20),
                                    height:
                                        MediaQuery.of(context).size.width > 800
                                            ? MediaQuery.of(context).size.height
                                            : MediaQuery.of(context).size.width,
                                    width: double.infinity,
                                    child: MapScreen(
                                      setCoord: true,
                                      onCreate: () {},
                                      areaSize: projectAddService.areaSize,
                                    ))),
                          ]),
                    ),
                    SizedBox(
                      height: MySpacer.medium,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              focusNode: _cancel,
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
                              focusNode: _submit,
                              height: 50,
                              color: Palette.drawerColor,
                              minWidth: double.infinity,
                              onPressed: () {
                                projectAddService.deleteAllImage();
                                if (_formKey.currentState!.validate()) {
                                  if (customerSelected != null) {
                                    setState(() {
                                      loader = true;
                                    });

                                    if (isEdit) {
                                      projectAddService.setOwner(
                                          customerSelected!.id, isEdit);
                                      projectAddService.addBodyEdit({
                                        "project_id":
                                            widget.projectToEdit!.id.toString()
                                      });

                                      projectAddService.addBodyEdit({
                                        "start_date": projectAddService
                                            .startDate
                                            .toString()
                                      });
                                      projectAddService.addBodyEdit({
                                        "end_date":
                                            projectAddService.endDate.toString()
                                      });

                                      if (projectAddService
                                              .assignIdsToAdd.length >
                                          0) {
                                        print("ADDING");
                                        projectAddService
                                            .assign(
                                                listAssignIds: projectAddService
                                                    .assignIdsToAdd
                                                    .toString()
                                                    .replaceAll("[", "")
                                                    .replaceAll("]", ""),
                                                projectId:
                                                    widget.projectToEdit!.id!)
                                            .whenComplete(() => projectProvider
                                                .fetchProjects());
                                      }
                                      if (projectAddService
                                              .assignIdsToRemove.length >
                                          0) {
                                        print("REMOVING");
                                        projectAddService
                                            .removeAssign(
                                                listAssignIds: projectAddService
                                                    .assignIdsToRemove
                                                    .toString()
                                                    .replaceAll("[", "")
                                                    .replaceAll("]", ""),
                                                projectId:
                                                    widget.projectToEdit!.id!)
                                            .whenComplete(() => projectProvider
                                                .fetchProjects());
                                      }

                                      projectAddService.addBodyEdit({
                                        "picture": projectAddService
                                            .converteduint8list()
                                      });

                                      projectAddService.addBodyEdit({
                                        "address": mapService.address.text,
                                      });

                                      projectProvider
                                          .updateProject(
                                              bodyToEdit:
                                                  projectAddService.bodyToEdit)
                                          .whenComplete(() {
                                        setState(() {
                                          loader = false;
                                        });
                                      });

                                      Navigator.pop(context);
                                    } else {
                                      ProjectModel newProject = ProjectModel(
                                          status: colorsSettings
                                              .indexOf(selectedStatus!),
                                          assigneeIds:
                                              projectAddService.assignIds,
                                          customerId: projectAddService
                                              .activeOwnerIndex,
                                          description:
                                              descriptionController.text,
                                          name: nameController.text,
                                          coordinates: mapService.coordinates,
                                          picture: projectAddService
                                              .converteduint8list(),
                                          startDate:
                                              projectAddService.startDate,
                                          endDate: projectAddService.endDate,
                                          address: mapService.address.text,
                                          areaSize: projectAddService.areaSize);

                                      projectProvider
                                          .createProjects(
                                        newProject: newProject,
                                      )
                                          .whenComplete(() {
                                        Provider.of<CustomerService>(context,
                                                listen: false)
                                            .workingProjectsCustomer(
                                                projectAddService
                                                    .activeOwnerIndex)
                                            .whenComplete(() {
                                          setState(() {
                                            loader = false;
                                          });
                                        });
                                        Navigator.pop(context);
                                      });
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        webBgColor:
                                            "linear-gradient(to right, #5585E5, #5585E5)",
                                        msg: "Please provide a client",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                        fontSize: 16.0);
                                  }
                                }
                              },
                              child: Text(
                                isEdit ? "Mettre à jour" : "Créer",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
