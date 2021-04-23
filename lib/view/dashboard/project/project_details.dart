import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/widgets/basicButton.dart';

class ProjectDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Palette.contentBackground,
              padding: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chantier XYZ",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            "Planifié du 03/05/20 au 06/07/20",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                      Spacer(),
                      BasicButton(buttonText: "Planning"),
                      SizedBox(
                        width: MySpacer.medium,
                      ),
                      BasicButton(buttonText: "Logs")
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
                    "Description",
                    style: transHeader,
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscingaadadfbv elit, sed do eius  mod tempor incididunt ut labore et dolore magnmagnaaliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text(
                              "JOHN DOE",
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text(
                              "JANE DOE",
                            ),
                          ],
                        ),
                      )),
                      Expanded(
                          child: Container(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text(
                              "JOHN DOE",
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.large,
                  ),
                  Text(
                    "Photo",
                    style: transHeader,
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                color: Colors.red,
                              )),
                              Text("Title")
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                color: Colors.red,
                              )),
                              Text("Title")
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                color: Colors.red,
                              )),
                              Text("Title")
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                color: Colors.red,
                              )),
                              Text("Title")
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                color: Colors.red,
                              )),
                              Text("Title")
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Container(
                                color: Colors.red,
                              )),
                              Text("Title")
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: Palette.contentBackground,
            padding: EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Statistics",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Heures Totales",
                          style: transHeader.copyWith(fontSize: 10),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "126",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              "/hrs",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.grey,
                    ),
                    Column(
                      children: [
                        Text(
                          "Heures Totales",
                          style: transHeader.copyWith(fontSize: 10),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "126",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              "/hrs",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.grey,
                    ),
                    Column(
                      children: [
                        Text(
                          "Heures Totales",
                          style: transHeader.copyWith(fontSize: 10),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "126",
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              "/hrs",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MySpacer.large,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Statistics",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    BasicButton(buttonText: "Warning")
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
                            leading: Icon(Icons.notification_important),
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
                            leading: Icon(Icons.notification_important),
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
                            leading: Icon(Icons.notification_important),
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
          ))
        ],
      ),
    );
  }
}
