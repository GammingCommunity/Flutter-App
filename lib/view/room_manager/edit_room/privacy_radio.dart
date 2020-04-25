import 'package:flutter/material.dart';

class EditPrivacyRadio extends StatefulWidget {
  final bool value;
  final bool checkedValue;
  final String title;
  final TextStyle textStyle;
  final Function onChange;
  EditPrivacyRadio({this.checkedValue,this.value, @required this.title, this.textStyle, this.onChange});
  @override
  _PrivacyRaidoState createState() => _PrivacyRaidoState();
}

class _PrivacyRaidoState extends State<EditPrivacyRadio> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: <Widget>[
        Radio<bool>(
            value: widget.value,
            groupValue: widget.checkedValue,
            onChanged: (bool newVal) {
              return widget.onChange(newVal);
            }),
        Text(widget.title, style: widget.textStyle)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
