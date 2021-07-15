import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/color_model.dart';
import 'package:uitemplate/models/warning.dart';
import 'package:uitemplate/services/add_warning_service.dart';
import 'package:uitemplate/services/project/project_service.dart';

class AddWaringScreen extends StatefulWidget {
  final int? projectId;
  const AddWaringScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  _AddWaringScreenState createState() => _AddWaringScreenState();
}

class _AddWaringScreenState extends State<AddWaringScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool loader = false;

  ColorModels? selectedStatus;

  final _title = FocusNode();
  final _desc = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    selectedStatus = colorsSettings[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var projectProvider = Provider.of<ProjectProvider>(
      context,
    );
    return Container(
      width: size.width,
      height: size.height,
      constraints:
          BoxConstraints(maxWidth: 800, maxHeight: (size.height * 0.3) + 70),
      padding: EdgeInsets.all(10),
      child: loader
          ? Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: MySpacer.small,
                ),
                Text("Adding Warning...")
              ],
            ))
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Warning",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Expanded(
                      child: Scrollbar(
                          child: ListView(
                    children: [
                      SizedBox(
                        height: MySpacer.large,
                      ),
                      RawKeyboardListener(
                        focusNode: _title,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title Required!';
                            }
                          },
                          onFieldSubmitted: (x) {
                            _desc.requestFocus();
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Title",
                              border: OutlineInputBorder(),
                              hintStyle: transHeader),
                          controller: titleController,
                        ),
                      ),
                      SizedBox(
                        height: MySpacer.small,
                      ),
                      TextFormField(
                        focusNode: _desc,
                        validator: (value) {
                          if (descController.text.isEmpty) {
                            return 'Description Required!';
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Description",
                          hintStyle: transHeader,
                          border: OutlineInputBorder(),
                        ),
                        controller: descController,
                      ),
                      Container(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (var color in colorsSettings)
                              color == selectedStatus
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 60,
                                        width: 200,
                                        child: Card(
                                          color: Palette.drawerColor,
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: color.color,
                                                ),
                                                SizedBox(
                                                  width: MySpacer.small,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "${color.name}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedStatus = color;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        height: 60,
                                        width: 200,
                                        child: Card(
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: color.color,
                                                ),
                                                SizedBox(
                                                  width: MySpacer.small,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "${color.name}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                        ),
                                      ),
                                    )
                          ],
                        ),
                      )
                    ],
                  ))),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: MaterialButton(
                              height: 60,
                              color: Colors.grey[200],
                              minWidth: double.infinity,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Annuler",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: MySpacer.medium),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            height: 60,
                            minWidth: double.infinity,
                            color: Palette.drawerColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loader = true;
                                });
                                AddWarning()
                                    .addWaring(
                                        widget.projectId.toString(),
                                        titleController.text,
                                        descController.text,
                                        colorsSettings
                                            .indexOf(selectedStatus!)
                                            .toString())
                                    .then((val) {
                                  setState(() {
                                    loader = false;
                                  });
                                  Navigator.pop(context);

                                  projectProvider.addWaring(WarningModel(
                                      val["id"],
                                      int.parse(val["user_id"]),
                                      int.parse(
                                        val["project_id"],
                                      ),
                                      val["title"],
                                      val["description"],
                                      int.parse(val["type"]),
                                      val[""],
                                      val["created_at"]));
                                });
                              }
                            },
                            child: Text(
                              "Créer",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
    );
  }
}
