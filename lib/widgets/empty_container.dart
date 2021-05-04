import 'package:flutter/material.dart';
import 'package:uitemplate/config/global.dart';
import 'package:uitemplate/config/pallete.dart';

import 'adding_button.dart';

class EmptyContainer extends StatelessWidget {
  final String? title;
  final String? description;
  final String? buttonText;
  final Widget? addingFunc;
  final bool showButton;

  const EmptyContainer(
      {Key? key,
      this.showButton = false,
      required this.addingFunc,
      required this.title,
      required this.description,
      required this.buttonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title!,
            style: boldText,
          ),
          SizedBox(
            height: MySpacer.large,
          ),
          Icon(Icons.file_present),
          SizedBox(
            height: MySpacer.small,
          ),
          // Its time to create a project \n choose the right client and location for your project
          Text(description!, textAlign: TextAlign.center),
          SizedBox(
            height: MySpacer.small,
          ),
          showButton
              ? Container(
                  width: 150,
                  child: Center(
                    child: AddingButton(
                        addingPage: addingFunc, buttonText: buttonText),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
