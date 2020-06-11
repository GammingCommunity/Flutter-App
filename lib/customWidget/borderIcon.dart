import 'package:flutter/material.dart';

class BorderIcon extends StatelessWidget {
  final double size;
  final IconData icon;
  final Color iconColor;
  final double borderSize;
  final Color backgroundColor;
  final Function onTap;
  final bool canPress;

  const BorderIcon({this.size, this.icon, this.onTap, this.canPress = false,this.iconColor, this.borderSize, this.backgroundColor});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:canPress ? () => onTap : null,
      child: Container(
        height: size,
        width: size,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(borderSize), color: backgroundColor),
        child: Icon(
          icon,
          color: iconColor,
          size: size - 10,
        ),
      ),
    );
  }
}
