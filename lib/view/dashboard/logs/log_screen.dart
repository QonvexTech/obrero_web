import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:readmore/readmore.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/log_model.dart';
import 'package:uitemplate/services/history_service.dart';
import 'package:uitemplate/services/log_service.dart';
import 'package:uitemplate/view_model/logs/loader.dart';
import 'package:uitemplate/view_model/logs/log_api_call.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Palette.contentBackground,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Les détails de"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Tous bûches",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SizedBox(
            height: MySpacer.large,
          ),
          Expanded(
            child: Container(
              child: StreamBuilder<List<LogModel>>(
                builder: (context, result) {
                  if (result.hasError) {
                    return Center(
                      child: Text(
                        "${result.error}",
                      ),
                    );
                  }
                  if (result.hasData && result.data!.length > 0) {
                    return Scrollbar(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: List.generate(
                          result.data!.length,
                          (index) => Slidable(
                            actionExtentRatio: 0.05,
                            child: Stack(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.notification_important_rounded,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: ListTile(
                                              title: Text(
                                                  "${result.data![index].title}"),
                                              subtitle: ReadMoreText(
                                                result.data![index].body
                                                    .toString(),
                                                trimLines: 2,
                                                trimLength: 390,
                                                trimMode: TrimMode.Length,
                                                trimCollapsedText:
                                                    'Montre plus',
                                                trimExpandedText:
                                                    'Montrer moins',
                                                style: TextStyle(
                                                    color: Colors.black),
                                                moreStyle: TextStyle(
                                                    color: Palette.drawerColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                lessStyle: TextStyle(
                                                    color: Palette.drawerColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ),
                                        SizedBox(
                                          width: MySpacer.large,
                                        ),
                                        SizedBox(
                                          width: MySpacer.small,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Text(
                                      "${months[DateTime.parse(result.data![index].created_at!).month]} ${DateTime.parse(result.data![index].created_at!).day}, ${DateTime.parse(result.data![index].created_at!).year}",
                                      style: TextStyle(color: Colors.black26),
                                    ))
                              ],
                            ),
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: [
                              IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.transparent,
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () {
                                    History()
                                        .removeNotification(
                                            id: result.data![index].id!)
                                        .whenComplete(() {
                                      logApiCall.fetchServer();
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: LogsLoader.load(),
                    );
                  }
                },
                stream: logService.stream$,
              ),
            ),
          )
        ],
      ),
    );
  }
}
