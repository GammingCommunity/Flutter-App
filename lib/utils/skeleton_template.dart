import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class SkeletonTemplate {
  static text(double height, double width, double borderRadius,[Color color = Colors.grey]) {
    return ContainerResponsive(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius)));
  }

  static image(double height, double width,[double borderRadius = 10000,Color color = Colors.grey]) {
    return ContainerResponsive(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ));
  }
}
