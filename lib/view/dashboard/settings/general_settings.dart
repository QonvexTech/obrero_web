import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AdaptiveContainer(children: [
          AdaptiveItem(
              content: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.red,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 800),
                color: Colors.grey,
                child: Column(),
              ),
            ),
          ))
        ]));
  }
}
