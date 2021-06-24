import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/color_model.dart';
import 'package:uitemplate/services/employee_service.dart';
import 'package:uitemplate/services/status_service.dart';
import 'package:uitemplate/view/dashboard/settings/warnings/color_change.dart';

class WarningSettings extends StatefulWidget {
  @override
  _WarningSettingsState createState() => _WarningSettingsState();
}

class _WarningSettingsState extends State<WarningSettings> {
  List<bool> showTextEdit = [];
  List<TextEditingController> nameContollers = [];
  TextEditingController? name1 = TextEditingController();
  TextEditingController? name2 = TextEditingController();
  TextEditingController? name3 = TextEditingController();
  TextEditingController? name4 = TextEditingController();

  bool canEdit = false;

  @override
  void initState() {
    showTextEdit = [false, false, false, false];
    nameContollers = [name1!, name2!, name3!, name4!];

    super.initState();
  }

  void setAllFalse() {
    for (int x = 0; x < showTextEdit.length; x++) {
      setState(() {
        showTextEdit[x] = false;
      });
    }
    setState(() {
      canEdit = false;
    });
  }

  @override
  void dispose() {
    name1!.dispose();
    name2!.dispose();
    name3!.dispose();
    name4!.dispose();
    super.dispose();
  }

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
                              showTextEdit[colorsSettings.indexOf(colorVal)]
                                  ? Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              onChanged: (x) {
                                                setState(() {
                                                  canEdit = true;
                                                });

                                                if (x.isEmpty) {
                                                  setState(() {
                                                    canEdit = false;
                                                  });
                                                }
                                              },
                                              controller: nameContollers[
                                                  colorsSettings
                                                      .indexOf(colorVal)],
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                  hintText: colorVal.name),
                                            ),
                                          ),
                                          IconButton(
                                            icon: canEdit
                                                ? Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                  ),
                                            onPressed: () {
                                              if (canEdit) {
                                                StatusName()
                                                    .renameStatus(
                                                        colorVal.id.toString(),
                                                        nameContollers[
                                                                colorsSettings
                                                                    .indexOf(
                                                                        colorVal)]
                                                            .text)
                                                    .whenComplete(() {
                                                  setState(() {
                                                    colorVal
                                                        .name = nameContollers[
                                                            colorsSettings
                                                                .indexOf(
                                                                    colorVal)]
                                                        .text;
                                                    setAllFalse();
                                                  });
                                                });
                                              } else {
                                                setAllFalse();
                                              }
                                            },
                                          )
                                        ],
                                      ))
                                  : TextButton(
                                      child: Text(
                                        "${colorVal.name}",
                                      ),
                                      onPressed: () {
                                        setAllFalse();
                                        setState(() {
                                          showTextEdit[colorsSettings
                                              .indexOf(colorVal)] = true;
                                        });
                                      },
                                    )
                            ],
                          ),
                        }
                      ],
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
