import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:provider/provider.dart';

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
    final screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
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
                            controller: emailController,
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
                            controller: phoneControlller,
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
            SizedBox(height: 20),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  onPressed: () {
                    // check user wanna verify account or not

                    // if not, skip and process create account
                    if (_isVerify) {
                    } else {
                      pageProvider.setPageIndex(4);
                      widget.controller.animateToPage(5,
                          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
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
// do email verfiy

bool emailVerfiy() {}

//do phone verify
