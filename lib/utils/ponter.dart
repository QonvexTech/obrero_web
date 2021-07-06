import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();

    return renderObject!.paintBounds
        .shift(Offset(translation!.x, translation.y));
  }
}
