import 'package:flutter/material.dart';

class CustomFooterFRefresh extends StatelessWidget {
  final String loadMessage;
  CustomFooterFRefresh({this.loadMessage = "Load More"});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 38,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                backgroundColor: Color(0xfff1f3f6),
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
                strokeWidth: 2.0,
              ),
            ),
            SizedBox(width: 9.0),
            Text(
              loadMessage,
              style: TextStyle(color: Color(0xff6c909b)),
            ),
          ],
        ));
  }
}
