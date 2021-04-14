import 'package:flutter/material.dart';
import 'package:uitemplate/screens/login/login_form.dart';

class DesktopMode extends StatefulWidget {
  @override
  _DesktopModeState createState() => _DesktopModeState();
}

class _DesktopModeState extends State<DesktopMode> {
  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;

    return Container(
        color: Color.fromRGBO(224, 245, 255, 1),
        child: Center(
            child: Container(
                height: heightSize * 0.65,
                width: widthSize * 0.65,
                child: Card(
                    elevation: 5,
                    child: Row(children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                              child: Align(
                            alignment: Alignment.center,
                            child: Image.network(
                                'https://raw.githubusercontent.com/RonaldoMurakamiK/flutter-web-login-ui/master/assets/images/login-image.png',
                                height: heightSize * 0.5,
                                width: widthSize * 0.5,
                                semanticLabel: 'test'),
                          ))),
                      Expanded(
                          flex: 1,
                          child: Container(
                              padding: EdgeInsets.only(top: 20),
                              color: Color.fromRGBO(41, 187, 255, 1),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        'https://raw.githubusercontent.com/RonaldoMurakamiK/flutter-web-login-ui/master/assets/images/login-form.png',
                                        height: heightSize * 0.2,
                                        width: widthSize * 0.15),
                                    SizedBox(height: 20),
                                    LoginForm(0, 0.009, 16, 0.04, 0.01, 0.04,
                                        75, 0.01, 0.007, 0.01, 0.006)
                                  ])))
                    ])))));
  }
}
