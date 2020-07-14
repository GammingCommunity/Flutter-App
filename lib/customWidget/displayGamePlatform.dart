import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DisplayGamePlatform extends StatelessWidget {
  Widget customSVG({double height = 20, double width = 20, bool isDark = true, String asset}) {
    return SvgPicture.asset(
      asset,
      height: height,
      width: width,
    );
  }

  getPlatform(String txt) {
    switch (txt) {
      case "Windows":
        return customSVG(asset: 'assets/platforms/windows-white.svg');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(),
    );
  }
}
