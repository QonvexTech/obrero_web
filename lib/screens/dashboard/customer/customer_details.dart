import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_add.dart';
import 'package:uitemplate/screens/dashboard/customer/customer_list.dart';
import 'package:uitemplate/services/customer_service.dart';
import 'package:uitemplate/widgets/adding_button.dart';
import 'package:uitemplate/widgets/map.dart';

class CustomerDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CustomerService customerService = Provider.of<CustomerService>(context);
    return Container(
      color: Palette.contentBackground,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            "JOHN DOE",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            "#1234",
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Téléphone", style: transHeader),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text("1234-678-899", style: boldText)
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
                              "Johndoe@gmail.com",
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
                            Text("LOREM IPSUM", style: boldText)
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
                  Text("Chantier XYZ"),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address",
                              style: transHeader,
                            ),
                            SizedBox(
                              height: MySpacer.small,
                            ),
                            Text(
                              "LOREM IPSUM DOLOR",
                              style: boldText,
                            )
                          ],
                        ),
                      ),
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
                    "Description",
                    style: transHeader,
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscingaadadfbv elit, sed do eius  mod tempor incididunt ut labore et dolore magnmagnaaliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
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
                          MaterialButton(
                            color: Palette.drawerColor,
                            onPressed: () {
                              customerService.setPage(CustomerList());
                            },
                            child: Text(
                              "CustomerList",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MySpacer.medium,
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: MapScreen(),
                          )),
                      SizedBox(
                        height: MySpacer.large,
                      ),
                      Expanded(
                          flex: 3,
                          child: Container(
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
                                    AddingButton(
                                      addingPage: CustomerAdd(),
                                      buttonText: "Créer",
                                    )
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
                          )),
                    ],
                  )))
        ],
      ),
    );
  }
}
