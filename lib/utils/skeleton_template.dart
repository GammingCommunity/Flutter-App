import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class SkeletonTemplate {
  static text(double height, double width, double borderRadius, [Color color = Colors.grey]) {
    return ContainerResponsive(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(borderRadius)));
  }

  static image(double height, double width,
      [double borderRadius = 10000, Color color = Colors.grey]) {
    return ContainerResponsive(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ));
  }

  static chatMessage(double height,[double borderRadius = 10000]) {
    return ContainerResponsive(
      height: height.h,
      width: Get.width,
     
      child: Row(
        children: [
          image(60, 60, borderRadius),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              text(15, 50, 15),
              SizedBox(height:10),
              text(15, 100, 15),
            ],
          )
        ],
      ),
    );
  }
}
