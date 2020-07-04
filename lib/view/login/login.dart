import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/view/login/login_input.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                  child: Column(children: <Widget>[
                Expanded(
                  flex: 2,
                  child: FaSlideAnimation.slideDown(
                    show: true,
                    delayed: 200,
                    child: Container(
                      height: 200,
                      width: Get.width,
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/icons/logo/brand.svg'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FaSlideAnimation.slideDown(
                    show: true,
                    delayed: 300,
                    child: LoginInput(),
                  ),
                )
              ])),
            ),
          );
        },
      ),
    );
  }
}
