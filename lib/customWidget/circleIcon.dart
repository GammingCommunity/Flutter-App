import 'package:flutter/material.dart';

class CircleIcon extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Function onTap;
  CircleIcon({this.icon, this.iconColor, this.iconSize, this.onTap});

  @override
  _CircleIconState createState() => _CircleIconState();
}

class _CircleIconState extends State<CircleIcon> {
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      type: MaterialType.circle,
      child: IconButton(
        icon: Icon(widget.icon),
        onPressed: () {
          return widget.onTap();
        },
        color: widget.iconColor ?? Theme.of(context).iconTheme.color ,
        iconSize: widget.iconSize,
      ),
    );
  }
}
