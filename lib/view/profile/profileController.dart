import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var _darkTheme = true.obs;
  var _enLang = true.obs;
  static ProfileController get to => Get.find();

  bool get isEn => this._enLang.value;
  bool get darkTheme => this._darkTheme.value;


  void changeTheme() {
    this._darkTheme.value = !this._darkTheme.value;
  }

  void setLanguage() {
    this._enLang.value = !this._enLang.value;
  }

  Future loggout() async {
    return Get.defaultDialog(
      title: "Log out",
      middleText: "Are you sure you want to log out?",
      actions: [
        FlatButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel")),
        RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () {
              Get.find<SharedPreferences>().setBool('isLogin', false);

              Get.offAllNamed(
                '/',
                predicate: (route) => false,
              );
            },
            child: Text("Log Out")),
      ],
    );

    //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }
}
