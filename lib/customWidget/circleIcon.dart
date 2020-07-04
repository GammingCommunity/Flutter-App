import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/profile/profileController.dart';
import 'package:get/get.dart';

class CircleIcon extends StatelessWidget {
  final String toolTip;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Function onTap;
  CircleIcon(
      {@required this.icon,
      this.iconColor,
      this.toolTip = "",
      this.iconBackgroundColor = Colors.transparent,
      this.iconSize = 20,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    //bool isDarkMode = ProfileController.to.darkTheme;
    return GetX<ProfileController>(
        builder: (v) => Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              type: MaterialType.circle,
              child: Container(
                //  height: widget.iconSize ,
                //  width: widget.iconSize ,
                //   alignment: Alignment.center,
                color: iconBackgroundColor,
                child: IconButton(
                    tooltip: toolTip,
                    icon: Icon(
                      icon,
                      color: iconColor,
                    ),
                    onPressed: () {
                      return onTap();
                    },
                    color:
                        iconColor == null ? (v.darkTheme ? Colors.white : Colors.black) : iconColor,
                    iconSize: iconSize),
              ),
            ));
  }
}
