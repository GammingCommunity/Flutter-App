import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/iconWithTitle.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:get/get.dart';

class ChatBottomSheet{
  static show() {
    return Get.bottomSheet(
        Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconWithTitle(
                    icon: FeatherIcons.image,
                    color: Color(0xff3282b8),
                    borderRadius: 20,
                    title: "Image",
                    onTap: () {},
                  ),
                  IconWithTitle(
                    icon: FeatherIcons.video,
                    color: Colors.indigo,
                    borderRadius: 20,
                    title: "Video",
                    onTap: () {},
                  ),
                  IconWithTitle(
                    icon: FeatherIcons.file,
                    color: Color(0xff543864),
                    borderRadius: 20,
                    title: "File",
                    onTap: () {},
                  )
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10))),
        backgroundColor: Get.isDarkMode ? AppColors.BACKGROUND_COLOR : Colors.white);
  }
}