import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/view/sign_up/step_sign_up/email.dart';
import 'package:gamming_community/view/sign_up/step_sign_up/gender.dart';
import 'package:gamming_community/view/sign_up/step_sign_up/password.dart';
import 'package:gamming_community/view/sign_up/step_sign_up/profile.dart';
import 'package:gamming_community/view/sign_up/step_sign_up/username.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'provider/sign_up_provider.dart';
import 'step_sign_up/dateOfBirth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    //          widget.controller.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
    var pageProvider = Provider.of<SignUpProvider>(context);

    return Consumer<SignUpProvider>(builder: (context, value, child) {
      int pageIndex = value.getPageIndex;
      return Scaffold(
        appBar: CustomAppBar(
          child: [
           Align(
                  alignment: Alignment.center,
                  child: Text("Sign Up"),
                )
          ],
          height: 50,
          onNavigateOut: () {
             value.getPageIndex > 0
                          ? {
                            pageController.animateToPage(pageIndex - 1,
                              duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn),
                              value.setPageIndex(pageIndex - 1)
                          }
                          : Get.back();
          },
          padding: EdgeInsets.all(0),
          backIcon: FeatherIcons.arrowLeft),
        
        body: Container(
            height: Get.height,
            width: Get.width,
            child: PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                DateOfBirth(controller: pageController),
                Gender(controller: pageController),
                UserName(controller: pageController),
                Password(controller: pageController),
                Email(controller: pageController),
                Profile()
              ],
            )),
      );
    });
  }
}
