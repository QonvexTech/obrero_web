import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/project/project_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/view/dashboard/project/project_list.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/empty_container.dart';
import 'package:uitemplate/widgets/map.dart';

class CustomerDetails extends StatefulWidget {
  final CustomerModel? customer;
  final String? fromPage;
  const CustomerDetails(
      {Key? key, required this.customer, required this.fromPage})
      : super(key: key);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> with SettingsHelper {
  bool loader = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      CustomerService customerService =
          Provider.of<CustomerService>(context, listen: false);

      customerService
          .workingProjectsCustomer(widget.customer!.id!)
          .whenComplete(() {
        print("customer project : ${customerService.customerProject!.length}");

        Provider.of<MapService>(context, listen: false)
            .mapInit(customerService.customerProject!, context);
        setState(() {
          loader = false;
        });
      });
    });
  }

  int activeProject = 0;

  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    ProjectProvider projectService = Provider.of<ProjectProvider>(context);
    MapService mapService = Provider.of<MapService>(context);

    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Palette.contentBackground,
        child: AdaptiveContainer(
            physics:
                ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
            children: [
              AdaptiveItem(
                height: MediaQuery.of(context).size.height,
                content: Container(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    bottom: 20,
                  ),
                  child: ListView(
                    children: [
                      backButton(
                          context,
                          widget.fromPage == "project"
                              ? projectService.setPage
                              : customerService.setPage,
                          widget.fromPage == "project"
                              ? ProjectList(
                                  assignUser: false,
                                )
                              : CustomerList()),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height * .15,
                            height: MediaQuery.of(context).size.height * .15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10000),
                                color: Colors.grey.shade100,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    offset: Offset(3, 3),
                                    blurRadius: 2,
                                  )
                                ],
                                image: DecorationImage(
                                    fit: widget.customer!.picture == null
                                        ? BoxFit.scaleDown
                                        : BoxFit.cover,
                                    alignment: widget.customer!.picture == null
                                        ? AlignmentDirectional.bottomCenter
                                        : AlignmentDirectional.center,
                                    image: fetchImage(
                                      netWorkImage: widget.customer?.picture,
                                    ),
                                    scale: 1)),
                          ),
                          SizedBox(
                            width: MySpacer.medium,
                          ),
                          Text(
                            "${widget.customer!.fname} ${widget.customer!.lname}",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySpacer.large,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("T??l??phone", style: transHeader),
                                SizedBox(
                                  height: MySpacer.small,
                                ),
                                Text("${widget.customer!.contactNumber}",
                                    style: boldText)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email", style: transHeader),
                                SizedBox(
                                  height: MySpacer.small,
                                ),
                                Text(
                                  "${widget.customer!.email}",
                                  style: boldText,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Adresse", style: transHeader),
                                SizedBox(
                                  height: MySpacer.small,
                                ),
                                Text("${widget.customer!.adress}",
                                    style: boldText)
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MySpacer.large,
                      ),
                      Text(
                        "D??tails du site",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: MySpacer.small,
                      ),
                      loader
                          ? Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : customerService.customerProject!.length == 0
                              ? EmptyContainer(
                                  addingFunc: ProjectAddScreen(
                                    customer: widget.customer,
                                  ),
                                  title: "No assigned project yet",
                                  description: "",
                                  buttonText: "",
                                  showButton: false,
                                )
                              : Column(
                                  children: [
                                    for (ProjectModel project
                                        in customerService.customerProject!)
                                      GestureDetector(
                                        onTap: () {
                                          print("Click");
                                          mapService.mapController!
                                              .showMarkerInfoWindow(MarkerId(
                                                  project.id.toString()));
                                          mapService.mapController!.moveCamera(
                                              CameraUpdate.newLatLng(
                                                  project.coordinates!));

                                          setState(() {
                                            activeProject = project.id!;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              // activeProject
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: activeProject ==
                                                          project.id
                                                      ? Palette.drawerColor
                                                      : Colors.transparent)),
                                          padding: EdgeInsets.all(8),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          constraints:
                                              BoxConstraints(minHeight: 100),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                project.name!,
                                                style: boldText,
                                              ),
                                              SizedBox(
                                                height: MySpacer.small,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Description",
                                                            style: transHeader),
                                                        ReadMoreText(
                                                          project.description!,
                                                          trimLines: 2,
                                                          trimLength: 290,
                                                          trimMode:
                                                              TrimMode.Length,
                                                          trimCollapsedText:
                                                              'Montre plus',
                                                          trimExpandedText:
                                                              'Montrer moins',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          moreStyle: TextStyle(
                                                              color: Palette
                                                                  .drawerColor,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          lessStyle: TextStyle(
                                                              color: Palette
                                                                  .drawerColor,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: MySpacer.medium,
                                                  ),
                                                  Container(
                                                    width: 300,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Address",
                                                                style:
                                                                    transHeader),
                                                            Text(
                                                              project.address ??
                                                                  "${project.coordinates!.latitude},${project.coordinates!.longitude}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              MySpacer.medium,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text("Status",
                                                                style:
                                                                    transHeader),
                                                            Text(
                                                              colorsSettingsStatus[
                                                                      project
                                                                          .status!]
                                                                  .name!,
                                                              style: TextStyle(
                                                                  color: colorsSettingsStatus[
                                                                          project
                                                                              .status!]
                                                                      .color),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
              AdaptiveItem(
                  content: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Chantier Emplacement",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MySpacer.medium,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: MapScreen(
                              setCoord: false,
                              onCreate: () {
                                //TODO: add
                              },
                              areaSize: 0,
                              isEdit: false,
                              projectId: "0",
                            ),
                          ),
                        ],
                      )))
            ]));
  }
}
