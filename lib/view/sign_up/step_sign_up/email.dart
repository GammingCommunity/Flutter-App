import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamming_community/customWidget/customInput.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:get/get.dart';

class Email extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX<SignUpController>(
      builder: (v) => Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verify Your Account ",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              SizedBox(height: 20),
              !v.validateType
                  ? FaSlideAnimation.slideLeft(
                      delayed: 200,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: CustomInput(
                                controller: s.emailController,
                                hintText: "Email",
                                onTap: () {},
                                textInputType: TextInputType.emailAddress,
                                hideClearText: true,
                                onChange: (value) => v.checkEmailVaild(value),
                                errorText: v.isEmailValid ? null : "Your email is not invaild",
                                onClearText: () => s.emailController.clear()),
                          ),
                          Positioned(
                            right: 10,
                            top: 0,
                            child: Switch(
                                value: v.validateType,
                                onChanged: (value) => v.clearInfo(context, value)),
                          ),
                        ],
                      ),
                    )
                  : FaSlideAnimation.slideLeft(
                      delayed: 400,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: CustomInput(
                                controller: s.phoneControlller,
                                hintText: "Phone",
                                hideClearText: true,
                                onClearText: () => s.phoneControlller.clear()),
                          ),
                          Positioned(
                            right: 10,
                            top: 0,
                            child: Switch(
                              value: v.validateType,
                              onChanged: (value) => v.clearInfo(context, value),
                            ),
                          ),
                        ],
                      ),
                    ),
              Text(
                  "Note: You can skip this step, but later you must provider your email to use all feature."),
              SizedBox(height: 30),
              ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      // check user wanna verify account or not

                      // if not, skip and process create account
                      if (v.isVerify) {
                      } else {
                        s.navigate(5);
                      }
                    },
                    child: v.isEmailValid ? Text("Verify") : Text("Skip"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
/*
class Email extends StatefulWidget {
  final PageController controller;
  Email({this.controller});
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> with AutomaticKeepAliveClientMixin {
  // switch between email or phone verify.
  bool _switch = false;
  //
  bool _isVerify = false;

  var emailController = TextEditingController();
  var phoneControlller = TextEditingController();

  bool get isEmailEmpty => emailController.text == "";
  bool get isPhoneEmpty => phoneControlller.text == "";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Verify Your Account ",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 20),
            !_switch
                ? FaSlideAnimation.slideLeft(
                    delayed: 200,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: TextField(
                            controller: s.emailController,
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40),
                            ],
                            onChanged: (value) {
                              !isEmailEmpty && Validators.isValidEmail(value)
                                  ? setState(() {
                                      _isVerify = true;
                                    })
                                  : setState(() {
                                      _isVerify = false;
                                    });
                            },
                            decoration: InputDecoration(
                                errorText: "Your email is not invaild",
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                hintText: "Email"),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 5,
                          child: Switch(
                              value: _switch,
                              onChanged: (value) {
                                phoneControlller.clear();
                                emailController.clear();
                                FocusScope.of(context).unfocus();
                                SystemChannels.textInput.invokeMethod('TextInput.hide');

                                setState(() {
                                  _switch = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  )
                : FaSlideAnimation.slideLeft(
                    delayed: 400,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: TextField(
                            controller: s.phoneControlller,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(40),
                            ],
                            decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                hintText: "Phone"),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 5,
                          child: Switch(
                              value: _switch,
                              onChanged: (value) {
                                phoneControlller.clear();
                                emailController.clear();
                                FocusScope.of(context).unfocus();
                                SystemChannels.textInput.invokeMethod('TextInput.hide');

                                setState(() {
                                  _switch = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
            Text(
                "Note: You can skip this step, but later you must provider your email to use all feature."),
            SizedBox(height: 30),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    // check user wanna verify account or not

                    // if not, skip and process create account
                    if (_isVerify) {
                    } else {
                      s.navigate(5);
                    }
                  },
                  child: _isVerify ? Text("Verify") : Text("Skip"),
                ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
*/
