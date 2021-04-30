import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';

class GeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Palette.contentBackground,
        child: AdaptiveContainer(children: [
          AdaptiveItem(
            content: Container(
              width: MediaQuery.of(context).size.width,
              color: Palette.contentBackground,
              child: Center(
                child: Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.25,
                    constraints: BoxConstraints(minWidth: 700),
                    child: Expanded(
                      child: Card(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Profile Settings",
                              style: boldText,
                            ),
                            Text("data"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]));
  }
}
