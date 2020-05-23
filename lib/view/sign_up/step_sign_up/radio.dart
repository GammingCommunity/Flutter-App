import 'package:flutter/material.dart';

class GenderRadio extends StatelessWidget {
  final String sexType;
  final bool groupValue;
  final bool value;
  final bool selected;
  final Function onChanged;
  GenderRadio({
    this.sexType,
    this.selected,
    this.groupValue,
    this.value,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(15),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (value != groupValue) {
            onChanged(value);
          }
        },
        child: Container(
          height: 60,
          width: screenSize.width / 2 - 30,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(width: 2, color: selected == true ? Colors.indigo : Colors.grey[600])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      sexType,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "GoogleSans-Medium",
                          fontSize: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Radio<bool>(
                        hoverColor: Colors.transparent,
                        value: value,
                        groupValue: groupValue,
                        onChanged: (bool newValue) {
                          onChanged(newValue);
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
