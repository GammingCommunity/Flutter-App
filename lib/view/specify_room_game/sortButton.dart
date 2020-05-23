import 'package:flutter/material.dart';

class SortButton extends StatefulWidget {
  final Function onSelected;
  final AnimationController animationController;
  SortButton({this.onSelected, this.animationController});
  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  bool isPress = false;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 30,
      minWidth: 50,
      child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: <Widget>[
              Text(isPress ? "Hide" : "Filter", style: TextStyle(color: Colors.white)),
              SizedBox(width: 5),
              Icon(isPress ? Icons.clear : Icons.arrow_drop_down, color: Colors.white)
            ],
          ),
          onPressed: () {
            if (isPress) {
              widget.onSelected(false);
              setState(() {
                isPress = !isPress;
              });
            } else {
              /*_animationController.reverse()
              _animationController.forward();*/
              widget.onSelected(true);
              setState(() {
                isPress = !isPress;
              });
            }
          }),
    );
  }
}
