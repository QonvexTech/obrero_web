import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/color_model.dart';
import 'package:uitemplate/view/dashboard/settings/warnings/color_change.dart';

class WarningSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.contentBackground,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Types de Warning",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: MySpacer.medium,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (ColorModels colorVal in colorsSettings) ...{
                          Row(
                            children: [
                              ColorChange(
                                colorModel: colorVal,
                                index: 1,
                              ),
                              SizedBox(
                                width: MySpacer.small,
                              ),
                              Text("${colorVal.name}")
                            ],
                          ),
                        }
                      ],
                    ),
                    SizedBox(
                      height: MySpacer.large,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container())
          ],
        ));
    ;
  }
}
