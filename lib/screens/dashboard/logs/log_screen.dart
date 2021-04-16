import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/widgets/basicButton.dart';
import 'package:uitemplate/widgets/map.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // EmployeeSevice customerService = Provider.of<EmployeeSevice>(context);
    return AdaptiveContainer(children: [
      AdaptiveItem(
          content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Détails du"),
            Text(
              "LOG DE XYZ LE 24/10/20",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: MySpacer.large,
            ),
            Container(
              color: Colors.red,
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "Heures Début",
                            style: transHeader.copyWith(fontSize: 10),
                          ),
                          Text(
                            "7:30",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "AM",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "Heures Début",
                            style: transHeader.copyWith(fontSize: 10),
                          ),
                          Text(
                            "7:30",
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            "AM",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blue,
              height: 300,
              child: Expanded(
                child: Column(
                  children: [
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
                    Text(
                      "DÉTAILS DU LOG",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
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
            )
          ],
        ),
      )),
      AdaptiveItem(
          content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: MapScreen(),
      ))
    ]);
  }
}
