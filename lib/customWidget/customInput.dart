import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final Function onSubmited;
  final Function onTap;
  final String hintText;
  final Color borderSideColor;
  final double borderRadius;
  final Function onClearText;
  final bool readOnly;

  const CustomInput(
      {@required this.controller,
      @required this.readOnly,
      @required this.onSubmited,
      @required this.onTap,
      @required this.hintText,
      @required this.borderSideColor,
      @required this.borderRadius,
      @required this.onClearText});

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTap: () => widget.onTap(),
      onSubmitted: (value) => widget.onSubmited(),
      readOnly: widget.readOnly,
      decoration: InputDecoration(
          filled: true,
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderSideColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderSideColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderSideColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          suffixIcon: Visibility(
              visible: true,
              child: CircleIcon(icon: FeatherIcons.x, onTap: () => widget.onClearText())),
          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
    );
  }
}
