import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController? controller;
  final Function? onChange;

  const SearchBox({Key? key, required this.controller, required this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.only(right: 5),
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
          color: Palette.contentBackground,
          borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width > 900 ? 5 : 10000)),
      width: MediaQuery.of(context).size.width / 3,
      height: 40,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          onChange!(value);
        },
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.black12),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black45,
            ),
            hintText: "Recherche",
            border: InputBorder.none),
      ),
    );
  }
}
