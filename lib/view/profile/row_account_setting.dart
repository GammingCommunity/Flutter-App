import 'package:flutter/material.dart';

final settingFont = TextStyle(fontWeight: FontWeight.bold);
rowAccountSetting(Icon icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: settingFont,
              ),
            ],
          ),
        ),
      ],
    );
  }