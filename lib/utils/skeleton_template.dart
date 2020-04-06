import 'package:flutter/material.dart';

class SkeletonTemplate {
  static text(double height, double width, double borderRadius,Color color) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius)));
  }

  static image(double height, double width, double borderRadius,Color color) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ));
  }
}
