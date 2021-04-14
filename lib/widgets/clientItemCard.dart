import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("ITEMS1"),
            Text("ITEMS2"),
            Text("ITEMS3"),
            Text("ITEMS4"),
            Text("ITEMS4"),
            Text("ITEMS4"),
            Row(
              children: [Icon(Icons.edit), Icon(Icons.delete)],
            )
          ],
        ),
      ),
    );
  }
}
