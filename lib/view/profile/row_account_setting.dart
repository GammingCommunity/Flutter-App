import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

final settingFont = TextStyle(fontWeight: FontWeight.bold);

class RowProfileSetting extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String text;
  final Function onTap;
  final Widget widget;
  final bool clickable;
  RowProfileSetting({this.icon,this.iconSize = 30, this.text, this.onTap, this.widget, this.clickable = true});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: clickable
          ? () {
              return onTap();
            }
          : null,
      child: ContainerResponsive(
        height: 50,
        width: ScreenUtil().uiWidthPx,
        child: Padding(
          padding: EdgeInsetsResponsive.only(left: 30),
          child: Row(
            children: <Widget>[
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10), color: Get.isDarkMode ? Colors.white : Colors.black),
                child: Icon(
                  icon,
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  size: iconSize,
                ),
              ),
              SizedBoxResponsive(
                width: 20,
              ),
              TextResponsive(
                text,
                style: settingFont,
              ),
              Spacer(),
              widget
            ],
          ),
        ),
      ),
    );
  }
}
