import 'package:flutter/material.dart';

class OnHover extends StatefulWidget {
  final Widget Function(bool isHovered) builder;
  final isAnimate;

  const OnHover({Key? key, required this.builder, this.isAnimate = true})
      : super(key: key);

  @override
  _OnHoverState createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final hovered = Matrix4.identity()..translate(-10, 0, 0);
    final transform = isHovered ? hovered : Matrix4.identity();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: widget.isAnimate ? transform : null,
        child: widget.builder(isHovered),
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
