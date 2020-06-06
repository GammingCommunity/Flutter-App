import 'package:flutter/material.dart';

class IconWithTitle extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String title;
  final Function onTap;
  final double borderRadius;
  final Color color;
  const IconWithTitle(
      {@required this.icon,
      this.borderRadius = 10,
      this.iconSize = 20,
      @required this.color,
      @required this.title,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () => onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration:
                      BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, size: iconSize)),
              SizedBox(width: 10),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}
