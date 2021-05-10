import 'package:flutter/material.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/log_service.dart';
import 'package:uitemplate/services/notification_services.dart';

class NotificationCard extends StatefulWidget {
  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(50, 50),
      icon: StreamBuilder<bool>(
          stream: rxNotificationService.streamNewMessage$,
          builder: (context, result) {
            if (result.hasError) {
              return Center(
                child: Text(
                  "${result.error}",
                ),
              );
            }
            if (result.hasData) {
              return Stack(
                children: [
                  Icon(Icons.notifications),
                  result.data! == true
                      ? Positioned(
                          // draw a red marble
                          top: 0.0,
                          right: 0.0,
                          child: new Icon(Icons.brightness_1,
                              size: 8.0, color: Colors.redAccent),
                        )
                      : Container()
                ],
              );
            } else {
              return Icon(Icons.notifications);
            }
          }),
      itemBuilder: (BuildContext context) {
        rxNotificationService.openMessage();
        return [
          PopupMenuItem(
            child: Container(
              width: 650,
              height: MediaQuery.of(context).size.height - 100,
              child: StreamBuilder<List<LogModel>>(
                  stream: logService.stream$,
                  builder: (context, result) {
                    if (result.hasError) {
                      return Center(
                        child: Text(
                          "${result.error}",
                        ),
                      );
                    }

                    if (result.hasData && result.data!.length > 0) {
                      return Container(
                        child: ListView(
                          children: List.generate(
                              result.data!.length,
                              (index) => Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .notification_important_rounded,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                  "${result.data![index].title}"),
                                              subtitle: Text(
                                                  "${result.data![index].body}"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      );
                    } else {
                      return Container(
                        width: 650,
                        child: Center(
                          child: Text("NO NOTIFICATION"),
                        ),
                      );
                    }
                  }),
            ),
          )
        ];
      },
    );
  }
}
