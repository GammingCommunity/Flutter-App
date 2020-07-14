import 'package:flutter/material.dart';

class CustomHeaderFRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          backgroundColor: Color(0xfff1f3f6),
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
          strokeWidth: 2.0,
        ),
      ),
    );
  }
}
