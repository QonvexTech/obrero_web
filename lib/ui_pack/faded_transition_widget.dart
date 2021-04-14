// import 'package:flutter/material.dart';
// import 'package:simple_animations/simple_animations.dart';

// class AnimatedWidgetX extends StatelessWidget {
//   final Widget child;
//   final double delay;
//   Duration duration = Duration(milliseconds: 500);
//   AnimatedWidgetX({@required this.child, @required this.delay, this.duration});
//   @override
//   Widget build(BuildContext context) {
//     final tween = MultiTrackTween([
//       Track("opacity").add(duration, Tween(begin: 0.0, end: 1.0)),
//       Track("translateY")
//           .add(duration, Tween(begin: -30.0, end: 0.0), curve: Curves.easeOut),
//     ]);
//     return ControlledAnimation(
//       delay: Duration(milliseconds: (duration.inMilliseconds * delay).round()),
//       duration: tween.duration,
//       tween: tween,
//       child: child,
//       builderWithChild: (_, child, animation) => Opacity(
//         opacity: animation['opacity'],
//         child: Transform.translate(
//           offset: Offset(0, animation['translateY']),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
