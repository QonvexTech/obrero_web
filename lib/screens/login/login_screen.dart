import 'package:flutter/material.dart';
import 'package:uitemplate/screens/login/desktop_mode.dart';
import 'package:uitemplate/screens/login/mobile_mode.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 1024) {
          return MobileMode();
        } else {
          return DesktopMode();
        }
      },
    );
  }
}
