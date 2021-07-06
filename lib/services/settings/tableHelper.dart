import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class TableHelper {
  //  "${data.fname} ${data.lname}?",
  static showDeleteCard(context, name, removeFunc, id) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
            backgroundColor: Palette.contentBackground,
            content: Container(
              constraints: BoxConstraints(maxWidth: 380),
              height: 80,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: MediaQuery.of(context).size.width < 750
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: MySpacer.small,
                      ),
                      MediaQuery.of(context).size.width < 750
                          ? Column(
                              children: [
                                Text("Are you sure to delete "),
                                Container(
                                  width: 160,
                                  child: Text(
                                    "$name?",
                                    style: TextStyle(
                                        color: Palette.drawerColor,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Text("Are you sure to delete "),
                                Container(
                                  width: 160,
                                  child: Text(
                                    "$name?",
                                    style:
                                        TextStyle(color: Palette.drawerColor),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(
                    height: MySpacer.small,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Colors.grey,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        width: MySpacer.medium,
                      ),
                      MaterialButton(
                        color: Palette.drawerColor,
                        onPressed: () {
                          removeFunc(id: id);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
