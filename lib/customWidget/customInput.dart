import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';

class CustomInput extends StatefulWidget {
  final TextEditingController controller;
  final Function onSubmited;
  final Function onClearText;
  final Function onTap;
  final Function onChange;
  final String hintText;
  final Color borderSideColor;
  final double borderRadius;
  final String errorText;
  final bool readOnly;

  const CustomInput(
      {@required this.controller,
      this.readOnly = false,
      this.onSubmited,
      this.onChange,
      this.errorText,
      this.onTap,
      this.hintText,
      this.borderSideColor = Colors.black87,
      this.borderRadius = 15,
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
      onChanged: (value) => widget.onChange(value),
      readOnly: widget.readOnly,
      decoration: InputDecoration(
          filled: true,
          hintText: widget.hintText,
          errorText: widget.errorText,
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
              child:CircleIcon(icon: FeatherIcons.x, onTap: () => widget.onClearText())
              ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
    );
  }
}
