import 'package:adaptive_container/adaptive_container.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
import 'package:uitemplate/widgets/searchBox.dart';

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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool hovering = false;

  // void _onRefresh() async{
  //   _refreshController.refreshCompleted();
  // }

  void _onLoading() async {
    //loader
    Provider.of<CustomerService>(context, listen: false).loadMore();

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    Provider.of<EmployeeSevice>(context, listen: false).fetchUsers();
    Provider.of<CustomerService>(context, listen: false).load();

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
                        children: [
                          MediaQuery.of(context).size.width < 1200
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: double.infinity,
                                  child: MapScreen())
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
                                      child: Text(
                                        "${mapService.coordinates.latitude},${mapService.coordinates.longitude}",
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        "${Provider.of<MapService>(context).addressGeo}",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                //CLIENTS
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: MySpacer.small),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 60,
                                          child: DropdownSearch<CustomerModel>(
                                            popupItemBuilder:
                                                _customPopupItemBuilderExample,
                                            mode: Mode.MENU,
                                            maxHeight: 700,
                                            isFilteredOnline: true,
                                            showClearButton: true,
                                            showSearchBox: true,
                                            hint: "Select client",
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .fillColor,
                                            ),
                                            autoValidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (u) => u == null
                                                ? "user field is required "
                                                : null,
                                            onFind: (String filter) =>
                                                customerService
                                                    .searchLoad(filter),
                                            // items: customerService.customersLoad,
                                            onChanged: (data) {
                                              print(data);
                                            },
                                            popupSafeArea: PopupSafeArea(
                                                top: true, bottom: true),
                                          ),
                                        ),

                                        // PopupMenuButton(
                                        //     onSelected: (val) {},
                                        //     offset: Offset(0, 50),
                                        //     icon: Icon(Icons.add_circle),
                                        //     itemBuilder: (context) => [
                                        //           PopupMenuItem(
                                        //             child: Padding(
                                        //                 padding: EdgeInsets.symmetric(
                                        //                     vertical: 5),
                                        //                 child: SearchBox(
                                        //                   controller: searchController,
                                        //                   onChange:
                                        //                       customerService.searchLoad,
                                        //                 )),
                                        //           ),
                                        //           PopupMenuItem(
                                        //             value: 1,
                                        //             child: Consumer<CustomerService>(
                                        //                 builder: (context, data, child) {
                                        //               try {
                                        //                 return Container(
                                        //                   width: 650,
                                        //                   height: 500,
                                        //                   child: customerService
                                        //                               .customersLoad
                                        //                               .length >=
                                        //                           10
                                        //                       ? SmartRefresher(
                                        //                           enablePullDown: false,
                                        //                           enablePullUp:
                                        //                               customerService
                                        //                                   .paginationLoad
                                        //                                   .isNext,
                                        //                           header: WaterDropHeader(),
                                        //                           footer: CustomFooter(
                                        //                             builder:
                                        //                                 (context, mode) {
                                        //                               Widget body;
                                        //                               if (mode ==
                                        //                                   LoadStatus.idle) {
                                        //                                 body = Text(
                                        //                                     "Load More...");
                                        //                               } else if (mode ==
                                        //                                   LoadStatus
                                        //                                       .loading) {
                                        //                                 body =
                                        //                                     CupertinoActivityIndicator();
                                        //                               } else if (mode ==
                                        //                                   LoadStatus
                                        //                                       .failed) {
                                        //                                 body = Text(
                                        //                                     "Load Failed!Click retry!");
                                        //                               } else if (mode ==
                                        //                                   LoadStatus
                                        //                                       .canLoading) {
                                        //                                 body = Center(
                                        //                                   child:
                                        //                                       CircularProgressIndicator(),
                                        //                                 );
                                        //                               } else {
                                        //                                 body = Text(
                                        //                                     "No more Data");
                                        //                               }
                                        //                               return Container(
                                        //                                 height: 55.0,
                                        //                                 width: 100,
                                        //                                 child: Center(
                                        //                                     child: body),
                                        //                               );
                                        //                             },
                                        //                           ),
                                        //                           controller:
                                        //                               _refreshController,
                                        //                           // onRefresh: _onRefresh,
                                        //                           onLoading: _onLoading,
                                        //                           child: ListView.builder(
                                        //                             itemCount:
                                        //                                 customerService
                                        //                                     .customersLoad!
                                        //                                     .length,
                                        //                             itemBuilder: (c, i) {
                                        //                               return Container(
                                        //                                   child: Card(
                                        //                                       child:
                                        //                                           ListTile(
                                        //                                 leading: CircleAvatar(
                                        //                                     foregroundImage: fetchImage(
                                        //                                         netWorkImage: customerService
                                        //                                             .customersLoad![
                                        //                                                 i]
                                        //                                             .picture)),
                                        //                                 title: Text(
                                        //                                     "${customerService.customersLoad![i].fname} ${customerService.customersLoad![i].lname}"),
                                        //                               )));
                                        //                             },
                                        //                           ))
                                        //                       : ListView.builder(
                                        //                           itemCount: customerService
                                        //                               .customersLoad!
                                        //                               .length,
                                        //                           itemBuilder: (c, i) {
                                        //                             return Container(
                                        //                                 child: Row(
                                        //                               children: [
                                        //                                 Text(
                                        //                                     "${customerService.customersLoad![i].fname} ${customerService.customersLoad![i].lname}")
                                        //                               ],
                                        //                             ));
                                        //                           },
                                        //                         ),
                                        //                 );
                                        //               } catch (e) {
                                        //                 return Text("$e");
                                        //               }
                                        //             }),
                                        //           ),
                                        //         ]),
                                      ],
                                    )),

                                // isEdit
                                //     ? Container(
                                //         margin: EdgeInsets.all(5),
                                //         height: 60,
                                //         width: 150,
                                //         child: Card(
                                //           color: Palette.drawerColor,
                                //           margin: EdgeInsets.all(0),
                                //           child: ListTile(
                                //             title: Text(
                                //               widget.projectToEdit!.owner!.fname ??
                                //                   "No owner",
                                //               style: TextStyle(color: Colors.white),
                                //             ),
                                //           ),
                                //         ))
                                //     : customerService.customers == null
                                //         ? Center(
                                //             child: CircularProgressIndicator(),
                                //           )
                                //         : customerService.customers.length == 0
                                //             ? Text("No client to assign")
                                //             : Container(
                                //                 height: 60,
                                //                 width: double.infinity,
                                //                 child: ListView.builder(
                                //                     scrollDirection: Axis.horizontal,
                                //                     itemCount:
                                //                         customerService.customers.length,
                                //                     itemBuilder: (context, index) {
                                //                       return projectAddService
                                //                                   .activeOwnerIndex ==
                                //                               customerService
                                //                                   .customers[index].id
                                //                           ? GestureDetector(
                                //                               onTap: () {},
                                //                               child: Container(
                                //                                   margin: EdgeInsets.all(5),
                                //                                   height: 60,
                                //                                   width: 150,
                                //                                   child: Card(
                                //                                     color:
                                //                                         Palette.drawerColor,
                                //                                     margin:
                                //                                         EdgeInsets.all(0),
                                //                                     child: ListTile(
                                //                                       title: Text(
                                //                                         customerService
                                //                                             .customers[
                                //                                                 index]
                                //                                             .fname,
                                //                                         style: TextStyle(
                                //                                             color: Colors
                                //                                                 .white),
                                //                                       ),
                                //                                     ),
                                //                                   )),
                                //                             )
                                //                           : GestureDetector(
                                //                               onTap: () {
                                //                                 print(
                                //                                     "tapping ${customerService.customers[index].id}");
                                //                                 setState(() {
                                //                                   projectAddService
                                //                                       .setOwner(
                                //                                           customerService
                                //                                               .customers[
                                //                                                   index]
                                //                                               .id,
                                //                                           isEdit);

                                //                                   print(customerService
                                //                                       .customers[index].id);
                                //                                 });
                                //                               },
                                //                               child: Container(
                                //                                 margin: EdgeInsets.all(5),
                                //                                 height: 60,
                                //                                 width: 150,
                                //                                 child: Card(
                                //                                   child: ListTile(
                                //                                     title: Text(
                                //                                         customerService
                                //                                             .customers[
                                //                                                 index]
                                //                                             .fname),
                                //                                   ),
                                //                                 ),
                                //                               ));
                                //                     }),
                                //               ),
                                //  EMPLOYEES

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: MySpacer.small),
                                  child: Text(
                                    isEdit
                                        ? "Assigned Employees"
                                        : "Employees to assign",
                                    style: boldText,
                                  ),
                                ),
                                employeeSevice.users == null
                                    ? Center(child: CircularProgressIndicator())
                                    : employeeSevice.users!.length == 0
                                        ? Text("No employee to assign")
                                        : Container(
                                            height: 60,
                                            width: double.infinity,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: employeeSevice
                                                    .users!.length,
                                                itemBuilder: (context, index) {
                                                  return projectAddService
                                                          .assignIds
                                                          .contains(
                                                              employeeSevice
                                                                  .users![index]
                                                                  .id)
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            projectAddService
                                                                .removeAssigne(
                                                                    employeeSevice
                                                                        .users![
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
                                                                              .users![index]
                                                                              .picture),
                                                                    ),
                                                                    SizedBox(
                                                                      width: MySpacer
                                                                          .small,
                                                                    ),
                                                                    Text(
                                                                      "${employeeSevice.users![index].fname!} ${employeeSevice.users![index].lname!}",
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
                                                                        .users![
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
                                                                              .users![index]
                                                                              .picture),
                                                                    ),
                                                                    SizedBox(
                                                                      width: MySpacer
                                                                          .small,
                                                                    ),
                                                                    Text(
                                                                      "${employeeSevice.users![index].fname!} ${employeeSevice.users![index].lname!}",
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
                                            projectAddService
                                                .addPicture(pickedFile);
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
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
                                      for (var image
                                          in projectAddService.projectImages)
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
                                                  fit: profileData?.picture ==
                                                              null &&
                                                          image == null
                                                      ? BoxFit.scaleDown
                                                      : BoxFit.cover,
                                                  alignment:
                                                      profileData?.picture ==
                                                                  null &&
                                                              image == null
                                                          ? AlignmentDirectional
                                                              .bottomCenter
                                                          : AlignmentDirectional
                                                              .center,
                                                  image: tempImageProvider(
                                                      file: image,
                                                      netWorkImage:
                                                          profileData?.picture,
                                                      defaultImage:
                                                          'icons/admin_icon.png'),
                                                  scale: profileData?.picture ==
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
                                SizedBox(
                                  height: 300,
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

Widget _customPopupItemBuilderExample(
    BuildContext context, CustomerModel item, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: Text(item.fname!),
      subtitle: Text(item.id.toString()),
      leading: CircleAvatar(
          // this does not work - throws 404 error
          // backgroundImage: NetworkImage(item.avatar ?? ''),
          ),
    ),
  );
}
