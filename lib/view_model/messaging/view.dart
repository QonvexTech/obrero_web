import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/models/employes_model.dart';
import 'package:uitemplate/services/employee_service.dart';

class Views {
  static TextEditingController message = new TextEditingController();
  static String? b64Image;
  static void onExitPage() {
    message.dispose();
  }

  static Widget textField(int maxLine, {ValueChanged? callback}) => Theme(
        data: ThemeData(primaryColor: Palette.drawerColor),
        child: TextField(
          controller: message,
          onChanged: callback,
          maxLines: maxLine,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              labelText: "Un message",
              alignLabelWithHint: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      );
  static Widget shimmerLoader() {
    return ListView(
      children: List.generate(
        15,
        (index) => Shimmer(
          duration: Duration(seconds: 3),
          interval: Duration(milliseconds: 800),
          color: Colors.grey.shade100,
          enabled: true,
          direction: ShimmerDirection.fromLTRB(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 15,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: Random().nextInt(200 - 60).toDouble(),
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static ImageProvider _imageProvider({String? image}) {
    if (image == null) {
      return AssetImage("assets/icons/admin_icon.png");
    } else {
      return NetworkImage("https://obrero.checkmy.dev$image");
    }
  }

  static Widget employeesList(List employee,
      {required ValueChanged<EmployeesModel> callback}) {
    return ListView(
      children: List.generate(
          employee.length,
          (index) => MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  callback(employee[index]);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                fit: employee[index].picture == null
                                    ? BoxFit.fitWidth
                                    : BoxFit.cover,
                                image: _imageProvider(
                                    image: employee[index].picture),
                                scale: employee[index].picture == null ? 5 : 1,
                                alignment: AlignmentDirectional.bottomCenter)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                  "${employee[index].fname.toString()} ${employee[index].lname.toString()}"),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                "${employee[index].email!}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
    );
  }
}
