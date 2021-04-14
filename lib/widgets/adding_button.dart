import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';

class AddingButton extends StatelessWidget {
  final Widget? addingPage;
  final String? buttonText;

  const AddingButton(
      {Key? key, @required this.addingPage, @required this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Palette.drawerColor,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                backgroundColor: Palette.contentBackground,
                content: addingPage));
      },
      child: Row(
        children: [
          Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
          SizedBox(
            width: MySpacer.small,
          ),
          Text(
            buttonText!,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
