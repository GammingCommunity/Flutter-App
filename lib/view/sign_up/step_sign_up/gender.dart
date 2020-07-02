import 'package:flutter/material.dart';
import 'package:gamming_community/view/profile/profileController.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:gamming_community/view/sign_up/step_sign_up/radio.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Gender extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: GetX<SignUpController>(
            builder: (v) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Select your gender ",
                      style: TextStyle(fontSize: 30),
                    ),
                                        
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GenderRadio(
                              groupValue: v.isMale.value,
                              onChanged: (value) {
                                v.genderSelected("male", value);
                              },
                              sexType: "Male",
                              selected: v.isMale.value,
                              value: true,
                            ),
                            GenderRadio(
                              groupValue: v.isFemale.value,
                              onChanged: (value) {
                                v.genderSelected("female", value);
                              },
                              sexType: "Female",
                              selected: v.isFemale.value,
                              value: true,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GenderRadio(
                          groupValue: v.isOther.value,
                          onChanged: (value) {
                            v.genderSelected("other", value);
                          },
                          sexType: "Other",
                          selected: v.isOther.value,
                          value: true,
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 30,
                    ),
                    ButtonTheme(
                        minWidth: 200,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          onPressed: v.checkGenderSelected ? () => v.checkGender() : null,
                          child: Text("Next"),
                        ))
                  ],
                )),
      ),
    );
  }
}

/*class Gender extends StatefulWidget {
  final PageController controller;
  Gender({this.controller});
  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> with AutomaticKeepAliveClientMixin{
  bool hasError = false;
  bool isMale = false;
  bool isFemale = false;
  bool isOther = false;
  String yourSelect = "";

  Future hideError() {
    return Future.delayed(Duration(seconds: 5), () {
      setState(() {
        hasError = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Select your gender ",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GenderRadio(
                      groupValue: isMale,
                      onChanged: (value) {
                        setState(() {
                          isMale = !isMale;
                          isFemale = false;
                          isOther = false;
                          yourSelect = "male";
                        });
                      },
                      sexType: "Male",
                      selected: isMale,
                      value: true,
                    ),
                    GenderRadio(
                      groupValue: isFemale,
                      onChanged: (value) {
                        setState(() {
                          isFemale = !isFemale;
                          isMale = false;
                          isOther = false;
                          yourSelect = "female";
                        });
                      },
                      sexType: "Female",
                      selected: isFemale,
                      value: true,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GenderRadio(
                  groupValue: isOther,
                  onChanged: (value) {
                    setState(() {
                      isOther = !isOther;
                      isFemale = false;
                      isMale = false;
                      yourSelect = "other";
                    });
                  },
                  sexType: "Other",
                  selected: isOther,
                  value: true,
                )
              ],
            ),
            /*SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: hasError,
                maintainAnimation: true,
                maintainState: true,
                child: FaSlideAnimation.slideDown(
                    delayed: 500, child: Text("* You must select one options")),
              ),
            ),*/
            SizedBox(
              height: 30,
            ),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onPressed: yourSelect == "" ? null :() async {
                    if (yourSelect == "") {
                      setState(() {
                        hasError = true;
                        hideError();
                      });
                    } else {
                      s.setPageIndex(0);
                    s.navigate(1);
                      pageProvider.setGender(yourSelect);
                      widget.controller.animateToPage(2,
                          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                    }
                  },
                  child: Text("Next"),
                ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}*/
