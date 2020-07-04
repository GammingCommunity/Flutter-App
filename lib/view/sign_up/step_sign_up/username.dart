import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customInput.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:get/get.dart';

class UserName extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX<SignUpController>(
        builder: (v) => Scaffold(
            body: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: Get.height,
                width: Get.width,
                child: Column(children: <Widget>[
                  Text(
                    "How we can call you ? ",
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 100,
                      child: CustomInput(
                          controller: v.userNameController,
                          readOnly: false,
                          onSubmited: () {},
                          onTap: () {},
                          errorText: v.isUsernameValid ? null : "Username not vaild",
                          onChange: (value) => v.checkUsernameVaild(value),
                          hintText: "Tell me your username",
                          borderSideColor: Colors.black87,
                          borderRadius: 15,
                          onClearText: () {
                            v.userNameController.clear();
                          })),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Note: Username limit to 8 characters.")),
                  SizedBox(
                    height: 30,
                  ),
                  ButtonTheme(
                      minWidth: 200,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        onPressed: v.isUsernameValid ? () => v.checkUserName() : null,
                        child: Text("Next"),
                      ))
                ]))));
  }
}

/*class UserName extends StatefulWidget {
  final PageController controller;
  UserName({this.controller});
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> with AutomaticKeepAliveClientMixin {
  var userNameController = TextEditingController();
  bool hasError = false;
  bool get isEmpty => userNameController.text == "";
  String get userName => userNameController.text;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);
    super.build(context);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: screenSize.height,
            width: screenSize.width,
            child: Column(children: <Widget>[
              Text(
                "How we can call you ? ",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 100,
                  child: CustomInput(
                      controller: userNameController,
                      readOnly: false,
                      onSubmited: () {},
                      onTap: () {},
                      errorText: hasError ? "Username not vaild" : null,
                      onChange: (value) {
                        if (Validators.isVaildUsername(value)) {
                          setState(() {
                            hasError = false;
                          });
                          return;
                        } else {
                          setState(() {
                            hasError = true;
                          });
                        }
                      },
                      hintText: "Tell me your username",
                      borderSideColor: Colors.black87,
                      borderRadius: 15,
                      onClearText: () {})),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Note: Username limit to 8 characters.")),
              SizedBox(
                height: 30,
              ),
              ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onPressed: isEmpty
                        ? null
                        : () {
                            pageProvider.setPageIndex(3);
                            pageProvider.setUsername(userName);
                            widget.controller.animateToPage(3,
                                duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                          },
                    child: Text("Next"),
                  ))
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}
*/
