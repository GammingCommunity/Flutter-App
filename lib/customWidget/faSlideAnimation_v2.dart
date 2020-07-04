import 'dart:async';

import 'package:flutter/material.dart';

class FaSlideAnimation extends StatefulWidget {
  final Widget child;
  final bool show;
  final int delayed;
  final Offset offsetStart;
  final Offset offsetEnd;
  FaSlideAnimation({this.child, this.show = true, @required this.delayed, @required this.offsetStart, @required this.offsetEnd});

  factory FaSlideAnimation.slideUp({Widget child, bool show = true, int delayed}) {
    return FaSlideAnimation(show: show, delayed: delayed, offsetStart: Offset(0,1), offsetEnd: Offset.zero ,child: child);
  }
  factory FaSlideAnimation.slideDown({Widget child, bool show = true, int delayed}) {
    return FaSlideAnimation(show: show, delayed: delayed, offsetStart: Offset.zero, offsetEnd:Offset(0,0), child: child);
  }
  factory FaSlideAnimation.slideLeft({Widget child, bool show = true, int delayed}) {
    return FaSlideAnimation(show: show, delayed: delayed, offsetStart: Offset(1,0), offsetEnd:Offset.zero,child: child);
  }
  factory FaSlideAnimation.slideRight({Widget child, bool show = true, int delayed}) {
    return FaSlideAnimation(show: show, delayed: delayed, offsetStart: Offset.zero,offsetEnd:Offset(1,0), child: child);
  }
  @override
  _FaSlideAnimationState createState() => _FaSlideAnimationState();
}

class _FaSlideAnimationState extends State<FaSlideAnimation> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> animation;

  @override
  void initState() {
    
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween(begin: widget.offsetStart, end: widget.offsetEnd)
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
    super.initState();
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
