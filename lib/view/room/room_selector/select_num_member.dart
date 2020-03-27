import 'package:flutter/material.dart';

class SelectNumOfMember extends StatelessWidget {
  final int defaultPosition;
  final bool selected;
  final Function selectedPosition;
  final int listWidget;
  final List<String> values;
  final Function selectedValue;
  const SelectNumOfMember(
      {this.selected,
      this.selectedPosition,
      this.defaultPosition,
      this.listWidget,
      this.values,
      this.selectedValue});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      width: screenSize.width - 40,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ActionChip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: index == defaultPosition ? Colors.indigo : Colors.grey,
                padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                onPressed: () {
                  selectedPosition(index);
                  selectedValue(int.parse(values[index]));
                },
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AnimatedPadding(
                      duration: Duration(milliseconds: 500),
                      padding:index == defaultPosition? EdgeInsets.all(3): EdgeInsets.all(0),
                      curve: Curves.fastOutSlowIn,
                      child: Visibility(visible: index == defaultPosition ? true : false, child: Icon(Icons.check))),
                    SizedBox(width: 5,),
                    Padding(padding: EdgeInsets.only(right:5),child: Text(values[index]))
                  ],
                ),
              ),
          separatorBuilder: (context, index) => SizedBox(
                width: 20,
              ),
          itemCount: listWidget),
    );
  }
}
