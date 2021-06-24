import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class BasicButton extends StatelessWidget {
  final String? buttonText;
  final Function? onPressed;
  final IconData? icon;

  const BasicButton(
      {Key? key, this.icon, required this.buttonText, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        disabledColor: Colors.black12,
        color: Palette.drawerColor,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        onPressed: this.onPressed == null
            ? null
            : () {
                this.onPressed!();
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Icon(icon),
            ),
            Text(
              buttonText!,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}
