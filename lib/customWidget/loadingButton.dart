import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final FocusNode focusNode;
  final String title;
  final List<Widget> widgets;
  final Future excutedFunc;
  final Function onPress;
  final Function onSuccess;
  final Function onFail;

  const LoadingButton(
      {this.focusNode,
      this.widgets,
      this.title = "Unknown",
      this.excutedFunc,
      this.onPress,
      this.onSuccess,
      this.onFail});

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      minWidth: MediaQuery.of(context).size.width,
      buttonColor: Colors.indigo,
      child: RaisedButton(
        focusNode: widget.focusNode,
        onPressed: () => widget.onPress(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20),
              ),
            ),
            for(var item in widget.widgets)
              item
          ],
        ),
      ),
    );
  }
}
