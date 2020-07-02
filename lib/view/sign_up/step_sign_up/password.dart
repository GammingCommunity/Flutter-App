import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customInput.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Password extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: Get.height,
            width: Get.width,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Create password ",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              GetX<SignUpController>(
                builder: (v) => Container(
                    height: 100,
                    child: CustomInput(
                      controller: v.passwordController,
                      onTap: () {},
                      onChange: (value) => v.checkPasswordVaild(value),
                      onClearText: () {
                        v.passwordController.clear();
                      },
                      errorText: v.isPasswordVaild.value ? null : "Password is not invaild",
                    )),
              ),
              Text(
                "Note: Must have at most 11 characters, must contain a number and not contain any special characters",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 20,
              ),
              GetX<SignUpController>(
                builder: (v) => ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onPressed: v.isPasswordVaild.value ? () => v.checkPassword() :  null ,
                      child: Text("Next"),
                    )),
              )
            ])));
  }
}

/*class Password extends StatefulWidget {
  final PageController controller;
  Password({this.controller});
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var passwordController = TextEditingController();
  bool hasError = false;
  bool get isEmpty => passwordController.text == "";
  String get password => passwordController.text;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: screenSize.height,
            width: screenSize.width,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Create password ",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 100,
                  child: CustomInput(
                    controller: passwordController,
                    onTap: () {},
                    onChange: (value) {
                      if (Validators.isValidPassword(value)) {
                        setState(() {
                          hasError = false;
                        });
                      } else {
                        setState(() {
                          hasError = true;
                        });
                      }
                    },
                    onClearText: () {
                      print("clear");
                    },
                    errorText: hasError ? "Password is not invaild" : null,
                  )),
              Text(
                "Note: Must have at most 11 characters, must contain a number and not contain any special characters",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onPressed: isEmpty
                        ? null
                        : () {
                            pageProvider.setPassword(password);
                            pageProvider.setPageIndex(3);
                            widget.controller.animateToPage(4,
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
