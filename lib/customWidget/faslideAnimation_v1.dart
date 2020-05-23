import 'dart:async';

import 'package:flutter/material.dart';

class FaSlideAnimation extends StatefulWidget {
  final Widget child;
  final bool show;
  final int delayed;
  FaSlideAnimation({this.child, this.show, @required this.delayed});
  @override
  _FaSlideAnimationState createState() => _FaSlideAnimationState();
}

class _FaSlideAnimationState extends State<FaSlideAnimation> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn))
          ..addListener(() {
            setState(() {});
          });
    widget.show
        ? Timer(Duration(milliseconds: widget.delayed), () {
            controller.forward();
          })
        : Timer(Duration(milliseconds: widget.delayed), () {
            controller.reverse();
          });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: FadeTransition(
        opacity: controller,
        child: widget.child,
      ),
    );
  }
}
