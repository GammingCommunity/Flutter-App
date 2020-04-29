import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

final settingFont = TextStyle(fontWeight: FontWeight.bold);

class RowProfileSetting extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onTap;
  final Widget widget;
  final bool clickable;
  RowProfileSetting({this.icon, this.text, this.onTap, this.widget, this.clickable = true});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: clickable ? () {
          return onTap();
        } : null,
        child: ContainerResponsive(
          height: 40,
          width: ScreenUtil().uiWidthPx,
          child: Padding(
            padding: EdgeInsetsResponsive.only(left: 30),
            child: Row(
              children: <Widget>[
                icon,
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
