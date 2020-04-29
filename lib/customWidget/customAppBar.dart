import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> child;
  final double height;
  final IconData backIcon;
  final double iconSize;
  final Function onNavigateOut;
  CustomAppBar(
      {@required this.child,
      @required this.height,
      @required this.onNavigateOut,
      this.iconSize = 20,
      @required this.backIcon});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: Row(
          children: <Widget>[
            CircleIcon(
              icon: widget.backIcon,
              iconSize: widget.iconSize,
              onTap: () => widget.onNavigateOut(),
            ),
            for (Widget widget in widget.child) widget
          ],
        ),
        preferredSize: Size.fromHeight(widget.height));
  }
}
