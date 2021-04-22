import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/firebase_message.dart';
import 'package:uitemplate/services/notification_services.dart';

class NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FireBase firebaseMessage = Provider.of<FireBase>(context);
    return StreamBuilder<List>(
        stream: rxNotificationService.$stream,
        builder: (context, snapshot) {
          return PopupMenuButton(
            offset: Offset(50, 50),
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                firebaseMessage.newMessage
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.green,
                        ))
                    : Container(),
              ],
            ),
            itemBuilder: (BuildContext context) {
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
                  for (var item in snapshot.data!) ...{
                    PopupMenuItem(
                      child: Container(
                        width: 650,
                        color: Colors.red,
                      ),
                    )
                  }
                }
              ];
            },
          );
        });
  }
}
