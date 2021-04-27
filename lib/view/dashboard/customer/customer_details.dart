import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/map.dart';

class CustomerDetails extends StatelessWidget {
  final CustomerModel? customer;

  const CustomerDetails({Key? key, required this.customer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
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
                    backButton(
                        context, customerService.setPage, CustomerList()),

                    SizedBox(
                      height: MySpacer.large,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                        ),
                        SizedBox(
                          width: MySpacer.small,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${customer!.fname} ${customer!.lname}",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            // Text(
                            //   "${customer!.contactNumber}",
                            //   style: Theme.of(context).textTheme.subtitle1,
                            // )
                          ],
                        )
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
                              Text("${customer!.contactNumber}",
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
                                "${customer!.email}",
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
                              Text("${customer!.adress}", style: boldText)
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MySpacer.large,
                    ),
                    // Text(
                    //   "Détails du site",
                    //   style: Theme.of(context).textTheme.headline5,
                    // ),
                    // SizedBox(
                    //   height: MySpacer.small,
                    // ),
                    // // Text("${customer!}"),
                    // SizedBox(
                    //   height: MySpacer.large,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Expanded(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         "Address",
                        //         style: transHeader,
                        //       ),
                        //       SizedBox(
                        //         height: MySpacer.small,
                        //       ),
                        //       Text(
                        //         "LOREM IPSUM DOLOR",
                        //         style: boldText,
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total des Heures Travaillées",
                                style: transHeader,
                              ),
                              SizedBox(
                                height: MySpacer.small,
                              ),
                              Text(
                                "32HRS",
                                style: boldText.copyWith(color: Colors.green),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status",
                                style: transHeader,
                              ),
                              SizedBox(
                                height: MySpacer.small,
                              ),
                              Text(
                                "En cours",
                                style: boldText,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: MySpacer.large,
                    ),
                    Text(
                      "Projets",
                      style: transHeader,
                    ),
                    SizedBox(
                      height: MySpacer.small,
                    ),
                    //TODO: LISTVIEW of projects
                    Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscingaadadfbv elit, sed do eius  mod tempor incididunt ut labore et dolore magnmagnaaliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
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
                              "Chantier emplacement",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MySpacer.medium,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: MapScreen(),
                        ),
                        SizedBox(
                          height: MySpacer.large,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Demande client et mise à jour",
                                    style: boldText,
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add_circle),
                                      onPressed: () {
                                        //LOGS
                                      })
                                ],
                              ),
                              SizedBox(
                                height: MySpacer.small,
                              ),
                              Expanded(
                                child: Container(
                                  child: ListView(
                                    children: [
                                      Card(
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.notification_important),
                                          title: Row(
                                            children: [
                                              Text("Chantier"),
                                              SizedBox(
                                                width: MySpacer.small,
                                              ),
                                              Text("Avril")
                                            ],
                                          ),
                                          subtitle: Text(
                                              "Attention, il nous manque les plaques pour le toit de la terrasse"),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.notification_important),
                                          title: Row(
                                            children: [
                                              Text("Chantier"),
                                              SizedBox(
                                                width: MySpacer.small,
                                              ),
                                              Text("Avril")
                                            ],
                                          ),
                                          subtitle: Text(
                                              "Attention, il nous manque les plaques pour le toit de la terrasse"),
                                        ),
                                      ),
                                      Card(
                                        child: ListTile(
                                          leading: Icon(
                                              Icons.notification_important),
                                          title: Row(
                                            children: [
                                              Text("Chantier"),
                                              SizedBox(
                                                width: MySpacer.small,
                                              ),
                                              Text("Avril")
                                            ],
                                          ),
                                          subtitle: Text(
                                              "Attention, il nous manque les plaques pour le toit de la terrasse"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )))
          ]));
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
