import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customInput.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX<SignUpController>(
        builder: (v) => SingleChildScrollView(
              child: Container(
                width: Get.width,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Pick your avatar",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 20),
                    // avatar here
                    DottedBorder(
                        color: Colors.indigo,
                        strokeWidth: 1,
                        radius: Radius.circular(15),
                        borderType: BorderType.RRect,
                        child: Container(
                          height: 150,
                          width: 150,
                          child: v.avatarPath == ""
                              ? InkWell(
                                  child: CircleIcon(
                                      icon: FeatherIcons.image,
                                      onTap: () {
                                        s.selectAvatar();
                                      }),
                                )
                              : Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(File(v.avatarPath)),
                                      ),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () {
                                          v.removeImage();
                                        },
                                        child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle, color: Colors.amber),
                                            child: Icon(
                                              FeatherIcons.x,
                                              color: Colors.black,
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      child: CustomInput(
                          controller: s.nickNameController,
                          hintText: "Nickname",
                          textAlign: TextAlign.center,
                          onTap: (){},
                          onChange: (value) => v.checkUNAvailability(value),
                          errorText: v.isUsernameValid ? null : "This name is not availability", 
                          hideClearText: true,
                          onClearText: () => s.phoneControlller.clear()),
                    ),

                    ButtonTheme(
                        minWidth: 200,
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          onPressed: v.avatarPath == "" ? null : () => v.createAccount(context),
                          child: Text(
                            "Create Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ),
            ));
  }
}

/*class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ImagePicker imagePicker;
  @override
  Widget build(BuildContext context) {
    var pageProvider = Provider.of<SignUpProvider>(context);
    return Container(
      height: Get.height,
      width: Get.width,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              "Pick your avatar",
              style: TextStyle(fontSize: 30),
            ),
          ),
          SizedBox(height: 20),
          // avatar here
          DottedBorder(
              color: Colors.indigo,
              strokeWidth: 1,
              radius: Radius.circular(15),
              borderType: BorderType.RRect,
              child: Container(
                height: 150,
                width: 150,
                child: InkWell(
                  child: CircleIcon(
                      icon: FeatherIcons.image,
                      onTap: () async {
                        try {
                          await imagePicker.getImage(source: ImageSource.gallery);
                        } catch (e) {}
                      }),
                ),
              )),
          SizedBox(
            height: 30,
          ),
          ButtonTheme(
              minWidth: 200,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                onPressed: () {
                  // check user wanna verify account or not

                  // if not, skip and process create account
                  pageProvider.createAccount();
                },
                child: Text("Create Account"),
              ))
        ],
      ),
    );
  }
}
*/
