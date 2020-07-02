import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ProfileController extends GetxController {
  var darkTheme = true.obs;
  bool enLang = true;
  static ProfileController get to => Get.find();

  @override
  void onInit() {
    Get.putAsync<SharedPreferences>(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("isEng", true);
      return prefs;
    });
    super.onInit();
  }

  void setTheme(bool e) {
    darkTheme.value = e;
  }

  void setLanguage() {
    enLang = !enLang;
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
