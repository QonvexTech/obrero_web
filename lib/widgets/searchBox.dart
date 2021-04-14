import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
          color: Palette.contentBackground,
          borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width > 900 ? 5 : 10000)),
      width: MediaQuery.of(context).size.width > 900
          ? MediaQuery.of(context).size.width / 3
          : 40,
      height: 40,
      child: MediaQuery.of(context).size.width > 900
          ? TextField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black12),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Recherche",
                  border: InputBorder.none),
            )
          : IconButton(icon: Icon(Icons.search), onPressed: () {}),
    );
  }
}
