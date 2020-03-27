import 'dart:ui';

import 'package:flutter/animation.dart';

class SlideTransitionAnimated{
  static var begin = Offset(0.0, 1.0);
  static var end = Offset.zero;
  static var curve = Curves.ease;
  static var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
}