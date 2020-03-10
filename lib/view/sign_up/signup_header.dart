import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final backgroundColor = Color(0xff322E2E);
  final titleScreen = TextStyle(fontSize: 35, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            image: DecorationImage(
                image: AssetImage("assets/images/signup_header.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 10,
              child: Material(
                type: MaterialType.circle,
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                child: IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed("/login");
                    }),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 120.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "SIGN IN",
                        style: titleScreen,
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
