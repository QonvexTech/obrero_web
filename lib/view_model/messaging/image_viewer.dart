import 'package:flutter/material.dart';
import 'package:uitemplate/view_model/messaging/view.dart';
import 'dart:convert';

class ImageViewer extends StatelessWidget {
  final ValueChanged callback;
  ImageViewer({Key? key, required  this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: (){
          callback(null);
        },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 15),
          child: Image.memory(base64.decode(Views.b64Image!)),
        ),
      ),
    );
  }
}
