import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/services/settings/color_change_service.dart';
import 'package:uitemplate/view/dashboard/settings/warnings/color_change.dart';

class WarningSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var colorService = Provider.of<ColorChangeService>(context);
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
                        Row(
                          children: [
                            ColorChange(
                              defColor: colorService.statusColors[0],
                              index: 0,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text("ORDINAIRE")
                          ],
                        ),
                        Row(
                          children: [
                            ColorChange(
                              defColor: colorService.statusColors[1],
                              index: 1,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text("MEDIUM")
                          ],
                        ),
                        Row(
                          children: [
                            ColorChange(
                              defColor: colorService.statusColors[2],
                              index: 2,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text("IMPORTANT")
                          ],
                        ),
                        Row(
                          children: [
                            ColorChange(
                              defColor: colorService.statusColors[3],
                              index: 3,
                            ),
                            SizedBox(
                              width: MySpacer.small,
                            ),
                            Text("FIXÉ")
                          ],
                        )
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
