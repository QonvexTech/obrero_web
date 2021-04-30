import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/customer_model.dart';
import 'package:uitemplate/models/project_model.dart';
import 'package:uitemplate/services/customer/customer_service.dart';
import 'package:uitemplate/services/map_service.dart';
import 'package:uitemplate/services/settings/helper.dart';
import 'package:uitemplate/view/dashboard/customer/customer_list.dart';
import 'package:uitemplate/widgets/back_button.dart';
import 'package:uitemplate/widgets/map.dart';

class CustomerDetails extends StatefulWidget {
  final CustomerModel? customer;
  const CustomerDetails({Key? key, required this.customer}) : super(key: key);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> with SettingsHelper {
  List<ProjectModel> customerProjects = [];
  @override
  void initState() {
    customerProjects =
        ProjectModel.fromJsonListToProject(widget.customer!.customerProjects!);
    Provider.of<MapService>(context, listen: false).mapInit(customerProjects);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    // Provider.of<MapService>(context, listen: false)
    //     .focusMap(coordinates: customerProjects[0].coordinates!);
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.customer!.fname} ${widget.customer!.lname}",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            "${widget.customer!.contactNumber}",
                            style: Theme.of(context).textTheme.subtitle1,
                          )
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

                  for (ProjectModel project in customerProjects)
                    Card(
                      child: ListTile(
                        title: Text(project.name!),
                        subtitle: Text(project.description!),
                      ),
                    )
                  //TODO: LISTVIEW of projects
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
                        child: MapScreen(
                          initialCoord: customerProjects.length > 0
                              ? customerProjects[0].coordinates
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: MySpacer.large,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        leading:
                                            Icon(Icons.notification_important),
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
                                        leading:
                                            Icon(Icons.notification_important),
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
                                        leading:
                                            Icon(Icons.notification_important),
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
  }
}
