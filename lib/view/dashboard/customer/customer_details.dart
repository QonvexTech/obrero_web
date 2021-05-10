import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';
import 'package:uitemplate/view/dashboard/project/project_add.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/empty_container.dart';
import 'package:uitemplate/widgets/map.dart';

class CustomerDetails extends StatefulWidget {
  final CustomerModel? customer;
  const CustomerDetails({Key? key, required this.customer}) : super(key: key);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> with SettingsHelper {
  @override
  void initState() {
    // Provider.of<MapService>(context, listen: false).mapInit(customerProjects);
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<CustomerService>(context, listen: false)
          .workingProjectsCustomer(widget.customer!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Palette.contentBackground,
        child: AdaptiveContainer(children: [
          AdaptiveItem(
            content: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(context, customerService.setPage, CustomerList()),
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
                                    netWorkImage: widget.customer?.picture),
                                scale:
                                    widget.customer!.picture == null ? 5 : 1)),
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
                            Text("Téléphone", style: transHeader),
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
                            Text("${widget.customer!.adress}", style: boldText)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  Text(
                    "Détails du site",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  customerService.customerProject == null
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : customerService.customerProject!.length == 0
                          ? EmptyContainer(
                              addingFunc: ProjectAddScreen(),
                              title: "No assigned project yet",
                              description: "Add project Now",
                              buttonText: "Add Project",
                              showButton: true,
                            )
                          : Column(
                              children: [
                                for (ProjectModel project
                                    in customerService.customerProject!)
                                  Column(
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
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Description",
                                                    style: transHeader),
                                                Text(project.description!),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Address",
                                                    style: transHeader),
                                                Text(
                                                  project.address ??
                                                      "${project.coordinates!.latitude},${project.coordinates!.longitude}",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Status",
                                                    style: transHeader),
                                                Text(
                                                  statusTitles[project.status!],
                                                  style: TextStyle(
                                                      color: statusColors[
                                                          project.status!]),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                          height: 30,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.asset(
                                              "assets/images/dashLine.png")),
                                      SizedBox(
                                        height: MySpacer.large,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                ],
              ),
            ),
          ),
          AdaptiveItem(
              content: Container(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Chantier Emplacement",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MySpacer.medium,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: MapScreen(),
                      ),

                      // Container(
                      //   height: MediaQuery.of(context).size.height * 0.35,
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             "Demande client et mise à jour",
                      //             style: boldText,
                      //           ),
                      //           IconButton(
                      //               icon: Icon(Icons.add_circle),
                      //               onPressed: () {
                      //                 //LOGS
                      //               })
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: MySpacer.small,
                      //       ),
                      //       Expanded(
                      //         child: Container(
                      //           child: ListView(
                      //             children: [
                      //               Card(
                      //                 child: ListTile(
                      //                   leading:
                      //                       Icon(Icons.notification_important),
                      //                   title: Row(
                      //                     children: [
                      //                       Text("Chantier"),
                      //                       SizedBox(
                      //                         width: MySpacer.small,
                      //                       ),
                      //                       Text("Avril")
                      //                     ],
                      //                   ),
                      //                   subtitle: Text(
                      //                       "Attention, il nous manque les plaques pour le toit de la terrasse"),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  )))
        ]));
  }
}
