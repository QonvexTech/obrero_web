import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  List<RemoteMessage> _messages = [];
  bool newMessage = false;
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
        newMessage = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        offset: Offset(50, 50),
        icon: Stack(
          children: [
            Icon(Icons.notifications),
            newMessage
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
        itemBuilder: (context) {
          setState(() {
            newMessage = false;
            print("false");
          });
          return [
            PopupMenuItem(
              child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: [
                      if (_messages.length <= 0)
                        Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(child: Text("No notification yet!")),
                        ),
                      for (RemoteMessage message in _messages)
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            child: Container(
                              child: ListTile(
                                leading: CircleAvatar(),
                                title: Text(message.notification!.title!),
                                subtitle:
                                    Text(message.sentTime!.hour.toString()),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
            )
          ];
        });
  }
}
