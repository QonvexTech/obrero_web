import 'package:flutter/material.dart';
import 'package:uitemplate/config/pallete.dart';
import 'package:uitemplate/widgets/basicButton.dart';

class MassageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ENVOYER UNE NOTIFICATION PUSH",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text("Lorem ipsum"),
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          color: Palette.drawerColor,
                          onPressed: () {},
                          child: Row(
                            children: [Icon(Icons.add), Text("Destinataires")],
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "Message"),
                    ),
                    BasicButton(buttonText: "Envoyer")
                  ],
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
