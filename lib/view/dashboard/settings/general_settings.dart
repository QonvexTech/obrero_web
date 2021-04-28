import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
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
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                color: Colors.grey,
                child: Column(
                  children: [Text("Profile Settings")],
                ),
              ),
            ),
          ))
        ]));
  }
}
