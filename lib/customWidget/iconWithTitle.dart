import 'package:flutter/material.dart';

enum Position { right, bottom }

class IconWithTitle extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final double buttonWidth;
  final double buttonHeight;
  final String title;
  final Function onTap;
  final double borderRadius;
  final Color color;
  final Color iconColor;
  final Position titlePosition;
  const IconWithTitle(
      {@required this.icon,
      this.borderRadius = 10,
      this.iconSize = 20,
      this.buttonHeight = 50,
      this.buttonWidth = 50,
      this.iconColor = Colors.white,
      this.titlePosition = Position.right,
      @required this.color,
      @required this.title,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          return onTap();
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: titlePosition == Position.right
              ? Row(
                  children: [
                    Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        decoration:
                            BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                        child: Icon(icon, size: iconSize)),
                    SizedBox(width: 10),
                    Text(title)
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        decoration:
                            BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          icon,
                          size: iconSize,
                          color: iconColor,
                        )),
                    SizedBox(height: 10),
                    Text(title)
                  ],
                ),
        ),
      ),
    );
  }
}
