import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveContainer(children: [
      AdaptiveItem(
          content: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Palette.contentBackground,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Détails du"),
            Text(
              "All logs",
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: MySpacer.large,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
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
          ],
        ),
      )),
    ]);
  }
}
