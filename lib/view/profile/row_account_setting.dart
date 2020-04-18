import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

final settingFont = TextStyle(fontWeight: FontWeight.bold);

class RowProfileSetting extends StatelessWidget {
  final Icon icon;
  final String text;
  final Function onTap;
  RowProfileSetting({this.icon, this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
