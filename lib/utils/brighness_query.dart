import 'dart:ui';

import 'package:flutter/material.dart';


bool checkBrightness(BuildContext context) {
  final Brightness brightnessValue= MediaQuery.of(context).platformBrightness;
  bool isDark= brightnessValue == Brightness.dark;
  return isDark;
}
