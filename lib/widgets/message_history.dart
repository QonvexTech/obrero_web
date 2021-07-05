import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';

class MessageHistory extends StatelessWidget {
  const MessageHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.contentBackground,
      child: ListView(
        children: [
          for (var mess in historyMessages.reversed)
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(minHeight: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Recieved by: ", style: transHeader),
                          Text(
                            "${mess["sent_to"]["first_name"]} ${mess["sent_to"]["last_name"]}",
                          ),
                        ],
                      ),
                      Text(
                          mess["created_at"] == null
                              ? ""
                              : "${months[DateTime.parse(mess["created_at"]).month]} ${DateTime.parse(mess["created_at"]).day}, ${DateTime.parse(mess["created_at"]).year} ",
                          style:
                              TextStyle(fontSize: 15, color: Colors.black54)),
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Message", style: transHeader),
                            ReadMoreText(
                              mess["message"] == null ? "" : mess["message"],
                              trimLines: 2,
                              trimLength: 100,
                              trimMode: TrimMode.Length,
                              trimCollapsedText: 'Montre plus',
                              trimExpandedText: 'Montrer moins',
                              style: TextStyle(color: Colors.black),
                              moreStyle: TextStyle(
                                  color: Palette.drawerColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              lessStyle: TextStyle(
                                  color: Palette.drawerColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MySpacer.medium,
                      ),
                      // Container(
                      //   width: 300,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text("Address", style: transHeader),
                      //           Text(
                      //             project.address ??
                      //                 "${project.coordinates!.latitude},${project.coordinates!.longitude}",
                      //             style: TextStyle(
                      //                 color: Colors.green,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         height: MySpacer.medium,
                      //       ),
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text("Status", style: transHeader),
                      //           Text(
                      //             statusTitles[project.status!],
                      //             style: TextStyle(
                      //                 color: colorsSettings[project.status!]
                      //                     .color),
                      //           )
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
