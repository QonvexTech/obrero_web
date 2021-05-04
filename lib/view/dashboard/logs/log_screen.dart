import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/log_model.dart';
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
          Text("Les détails de"),
          Text(
            "Tous bûches",
            style: Theme.of(context).textTheme.headline6,
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
                            (index) => Card(
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
