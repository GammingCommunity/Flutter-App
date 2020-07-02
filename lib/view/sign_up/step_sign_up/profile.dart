import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetX<SignUpController>(
        builder: (v) => Container(
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
                              onTap: () {
                                s.selectAvatar();
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
                          v.createAccount();
                        },
                        child: Text("Create Account"),
                      ))
                ],
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
