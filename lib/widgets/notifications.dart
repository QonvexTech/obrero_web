import 'package:flutter/material.dart';
import 'package:uitemplate/services/notification_services.dart';

class NotificationCard extends StatefulWidget {
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
        stream: rxNotificationService.$stream,
        builder: (context, snapshot) {
          return PopupMenuButton(
            offset: Offset(50, 50),
            icon: StreamBuilder<bool>(
                stream: rxNotificationService.$streamNewMessage,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return Stack(
                    children: [
                      Icon(Icons.notifications),
                      snapshot.data!
                          ? Positioned(
                              // draw a red marble
                              top: 0.0,
                              right: 0.0,
                              child: new Icon(Icons.brightness_1,
                                  size: 8.0, color: Colors.redAccent),
                            )
                          : SizedBox()
                    ],
                  );
                }),
            itemBuilder: (BuildContext context) {
              rxNotificationService.openMessage();
              return [
                if (snapshot.data!.length == 0) ...{
                  PopupMenuItem(
                    child: Container(
                      width: 650,
                      child: Center(
                        child: Text("NO NOTIFICATION"),
                      ),
                    ),
                  )
                } else ...{
                  PopupMenuItem(
                    child: Container(
                        width: 650,
                        height: MediaQuery.of(context).size.height - 100,
                        child: ListView(
                          children: [
                            for (var item in snapshot.data!)
                              ListTile(
                                leading: CircleAvatar(),
                                title: Text(item["title"]),
                                subtitle: Text(item["created_at"]
                                    .toString()
                                    .split(" ")[0]),
                              ),
                          ],
                        )),
                  )
                }
              ];
            },
          );
        });
  }
}
