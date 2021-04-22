import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/services/notofication.dart';

class NotificationCard extends StatefulWidget {
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  List<RemoteMessage> _messages = [];
  bool newMessage = false;
  @override
  void initState() {
    // TODO: implement initState
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
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
            _messages.length > 0
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
        itemBuilder: (context) => [
              PopupMenuItem(
                child: Container(
                    height: MediaQuery.of(context).size.height - 100,
                    width: MediaQuery.of(context).size.width / 3,
                    child: ListView(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // showToastWidget(
                            //     Center(
                            //       child: Container(
                            //         color: Colors.transparent,
                            //         margin: EdgeInsets.only(top: 30),
                            //         child: ClipRRect(
                            //           child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.start,
                            //             children: [
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.end,
                            //                 children: [
                            //                   Card(
                            //                     child: Container(
                            //                         padding: EdgeInsets.all(10),
                            //                         width: 300.0,
                            //                         height: 80.0,
                            //                         color: Palette
                            //                             .contentBackground,
                            //                         child:
                            //                             Text("Notifications")),
                            //                   ),
                            //                   SizedBox(
                            //                     width: 60,
                            //                   )
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ), onDismiss: () {
                            //   print(
                            //       "the toast dismiss"); // The method will be called on toast dismiss.
                            // }, position: ToastPosition.bottom);
                          },
                          child: Card(
                            child: ListTile(
                              leading: CircleAvatar(),
                              title: Text("notification.body!"),
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            ]);
  }
}
