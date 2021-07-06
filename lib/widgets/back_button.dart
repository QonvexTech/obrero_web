import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

Widget backButton(context, Function onpress, Widget page) {
  return AppBar(
    centerTitle: false,
    title: Text(
      "Retour",
      style: TextStyle(color: Theme.of(context).accentColor),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Palette.drawerColor,
      ),
      onPressed: () {
        onpress(page: page);
      },
    ),
  );
}
