import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/LoginData.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var _showPwd = true.obs;
  var _isValidate = false.obs;
  var _query = GraphQLQuery();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode loginButtonFocus = FocusNode();

  String get username => this.usernameCtrl.text;
  String get password => this.passwordCtrl.text;
  bool get showPwd => this._showPwd.value;
  bool get isValidate => this._isValidate.value;

  validateUsername(String text) {
    return !Validators.isVaildUsername(text) ? 'Invalid Username' : null;
  }

  validatePassword(String text) {
    return !Validators.isValidPassword(text) ? "Invaild password" : null;
  }

  nextFocus(BuildContext context, FocusNode focusNode) {
    return FocusScope.of(context).requestFocus(focusNode);
  }

  get hidePwd => this._showPwd.value = !this._showPwd.value;

  isAllValidate() {
    if (formKey.currentState.validate()) {
      _isValidate.value = true;
    }
  }

  Future login(BuildContext context) async {
    // login
    Get.dialog(Center(
        child: Container(
      height: 100,
      width: 100,
      color: Colors.black,
      child: AppConstraint.loadingIndicator(context),
    )));
    var result = await SubRepo.queryGraphQL(
        await getToken(), _query.login(usernameCtrl.text.trim(), passwordCtrl.text.trim()));
    LoginData loginData = LoginData.fromJson(result.data);

    if (loginData.status == "SUCCESS") {
      SharedPreferences refs = await SharedPreferences.getInstance();
      refs.setStringList("loginInfo", [username, password]);
      refs.setString("userToken", loginData.token);
      refs.setString("userID", loginData.userID);
      refs.setString("userProfile", loginData.userProfile ?? AppConstraint.default_profile);
      refs.setString("userName", loginData.userName);
      refs.setBool("isLogin", true);
      print(refs.getStringList("loginInfo"));
      Get.back();
      BotToast.showText(
          text: "Login success. Welcome back, ${loginData.userName}",
          animationDuration: Duration(milliseconds: 200),
          duration: Duration(seconds: 2));
      Get.offAndToNamed('/homepage');
      //print("loginBloc "+loginData.userID + refs.getBool("isLogin ").toString() + loginData.userProfile + loginData.userName );
    } else {
      Get.back();
      BotToast.showText(
        text: "Login fail. Try again",
        animationDuration: Duration(milliseconds: 200),
      );
    }
  }
}
