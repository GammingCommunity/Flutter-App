<<<<<<< HEAD
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
=======
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
>>>>>>> 18325bbeee3512d61d0afa5b5d870b5a902264ca
  }