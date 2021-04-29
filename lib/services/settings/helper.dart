import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../config/global.dart';

class SettingsHelper {
  TextEditingController email = new TextEditingController()
    ..text = profileData!.email!;
  TextEditingController first_name = new TextEditingController()
    ..text = profileData!.firstName!;
  TextEditingController last_name = new TextEditingController()
    ..text = profileData!.lastName!;
  TextEditingController password = new TextEditingController();

  setInit(TextEditingController controller, String string) {
    controller.text = string;
  }

  Widget customTextField(
      {required TextEditingController controller, required String label}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }

  ImageProvider tempImageProvider({Uint8List? file}) {
    if (file == null) {
      if (profileData!.picture == null) {
        return AssetImage('icons/admin_icon.png');
      } else {
        return NetworkImage(
            "https://obrero.checkmy.dev${profileData!.picture}");
      }
    } else {
      return MemoryImage(file);
    }
  }

  ImageProvider get imageProvider {
    if (profileData!.picture == null) {
      return AssetImage('icons/admin_icon.png');
    } else {
      return NetworkImage("https://obrero.checkmy.dev${profileData!.picture}");
    }
  }

  HtmlElementView get viewWebImage {
    return HtmlElementView(viewType: "${profileData!.picture}");
  }
}
