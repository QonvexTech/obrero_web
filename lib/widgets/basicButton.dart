import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class BasicButton extends StatelessWidget {
  final String? buttonText;

  const BasicButton({Key? key, @required this.buttonText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Palette.drawerColor,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        onPressed: () {},
        child: Text(
          buttonText!,
          style: TextStyle(color: Colors.white),
        ));
  }
}
