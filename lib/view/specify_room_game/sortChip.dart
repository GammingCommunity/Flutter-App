import 'package:flutter/material.dart';

class SortChip extends StatefulWidget {
  final Function onSelected;
  SortChip({this.onSelected});
  @override
  _SortChipState createState() => _SortChipState();
}

class _SortChipState extends State<SortChip> {
  bool smallGroup = false;
  bool largeGroup = false;
  bool none = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ChoiceChip(
            label: Text("< 4"),
            selected: smallGroup,
            onSelected: (selected) {
              setState(() {
                smallGroup = !smallGroup;
                largeGroup = false;
                none = false;
              });
              return widget.onSelected("small");
            }),
        ChoiceChip(
            label: Text("> 4"),
            selected: largeGroup,
            onSelected: (selected) {
              setState(() {
                largeGroup = !largeGroup;
                smallGroup = false;
                none = false;
              });
              widget.onSelected("large");
            }),
        ChoiceChip(
          label: Text("None"),
          selected: none,
          onSelected: (selected) {
            setState(() {
              //none = !none;
              smallGroup = false;
              largeGroup = false;
            });
            widget.onSelected("none");
          },
        )
      ],
    );
  }
}
