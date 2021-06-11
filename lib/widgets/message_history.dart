import 'package:flutter/material.dart';

class MessageHistory extends StatelessWidget {
  const MessageHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ListView(
        children: [
          ListTile(
            title: Text("Title"),
          )
        ],
      ),
    );
  }
}
