import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final bool darkMode;
  final double size;
  CustomLoadingIndicator({this.darkMode,this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: size,
                width: size,
                child: darkMode
                    ? Image.asset("assets/loading/white_200.gif")
                    : Image.asset("assets/loading/black_200.gif"),
              ),
            ]));
  }
}
