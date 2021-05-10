import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

// see https://pub.dev/packages/universal_html

class HandCursor extends MouseRegion {
  // get a reference to the body element that we previously altered
  static final appContainer =
      html.window.document.getElementById('app-container');

  HandCursor(
      {required Widget child,
      required Function onHoverFunc,
      required Function onExitFun})
      : super(
            onHover: (PointerHoverEvent evt) {
              appContainer!.style.cursor = 'crosshair';
              onHoverFunc();
              // you can use any of these:
              // 'help', 'wait', 'move', 'crosshair', 'text' or 'pointer'
              // more options/details here: http://www.javascripter.net/faq/stylesc.htm
            },
            onExit: (PointerExitEvent evt) {
              // set cursor's style 'default' to return it to the original state
              appContainer!.style.cursor = 'default';
              onExitFun();
            },
            child: child);
}
