import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:uitemplate/view/login/login_form.dart';

class SequenceAnimationView extends StatefulWidget {
  @override
  _SequenceAnimationViewState createState() => _SequenceAnimationViewState();
}

class _SequenceAnimationViewState extends State<SequenceAnimationView>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    controller = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 100),
          from: const Duration(milliseconds: 200),
          to: const Duration(milliseconds: 300),
          tag: 'grow',
        )
        .addAnimatable(
          animatable: Tween<int>(begin: 3, end: 1),
          from: const Duration(milliseconds: 200),
          to: const Duration(milliseconds: 300),
          tag: 'flex',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 0, end: 1.0),
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 900),
          tag: 'fade-in',
        )
        .addAnimatable(
          animatable: Tween<double>(begin: 100, end: 0),
          from: const Duration(milliseconds: 300),
          to: const Duration(milliseconds: 800),
          tag: 'margin-slide',
        )
        .animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double widthSize = MediaQuery.of(context).size.width;
    final double heightSize = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) => Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Opacity(
                      opacity: sequenceAnimation["fade-in"].value,
                      child: Container(
                          child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                            'https://raw.githubusercontent.com/RonaldoMurakamiK/flutter-web-login-ui/master/assets/images/login-image.png',
                            height: heightSize * 0.5,
                            width: widthSize * 0.5,
                            semanticLabel: 'test'),
                      )),
                    )),
                Expanded(
                    flex: 1,
                    child: Opacity(
                      opacity: sequenceAnimation["fade-in"].value,
                      child: Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/logo.png',
                                    height: heightSize * 0.2,
                                    width: widthSize * 0.15),
                                SizedBox(
                                    height: sequenceAnimation["margin-slide"]
                                        .value),
                                LoginForm(0, 0.009, 16, 0.04, 0.01, 0.04, 75,
                                    0.01, 0.007, 0.01, 0.006)
                              ])),
                    )),
              ],
            ));
  }
}
