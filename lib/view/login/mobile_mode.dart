import 'package:flutter/material.dart';
import 'package:uitemplate/view/login/login_form.dart';

class MobileMode extends StatefulWidget {
  @override
  _MobileModeState createState() => _MobileModeState();
}

class _MobileModeState extends State<MobileMode> {
  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: Container(
                color: Color.fromRGBO(224, 245, 255, 1),
                child: Column(children: [
                  Image.asset('assets/icons/logo.png',
                      height: heightSize * 0.3, width: widthSize * 0.6),
                  SingleChildScrollView(
                      child: LoginForm(
                          0.007,
                          0.04,
                          widthSize * 0.04,
                          0.06,
                          0.04,
                          0.07,
                          widthSize * 0.09,
                          0.03,
                          0.032,
                          0.04,
                          0.032))
                ]))));
  }
}
