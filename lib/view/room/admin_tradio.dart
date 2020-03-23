import 'package:flutter/material.dart';

class AdminRadio extends StatelessWidget {
  final String content, privacyType;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final bool selected;
  final Function onChanged;
  final Function onChangeType;
  AdminRadio({
    this.onChangeType,
    this.privacyType,
    this.content,
    this.selected,
    this.padding,
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
            onChangeType(value);
          }
        },
        child: Container(
          height: 110,
          width: screenSize.width / 2 - 30,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 2,
                  color: selected == true ? Colors.indigo : Colors.grey[600])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      privacyType,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "GoogleSans-Medium",
                          fontSize: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Radio<bool>(
                        value: value,
                        groupValue: groupValue,
                        onChanged: (bool newValue) {
                          onChanged(newValue);
                          onChangeType(newValue);
                        }),
                  ),
                ],
              ),
              Text(content,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: TextStyle(fontFamily: "GoogleSans-Medium"),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
