import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();
  var mutation = GraphQLMutation();
  ImagePicker imagePicker = ImagePicker();

  var _gender = "".obs;
  var _currentPage = 0.obs;
  var hasError = false.obs;
  var _validateType = false.obs;
  var _isPasswordVaild = false.obs;
  var _isUsernameVaild = false.obs;
  var _isEmailVaild = false.obs;
  var _isVerify = false.obs;
  var _isMale = false.obs;
  var _isFemale = false.obs;
  var _isOther = false.obs;
  var _dateOfBirth = "".obs;
  var _avatarPath = "".obs;

  var pageController = PageController();
  var dateofBirthController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneControlller = TextEditingController();
  var nickNameController = TextEditingController();
  Future<void> selectDate(BuildContext ctx) async {
    DateTime selectedDate = DateTime.now();
    DateTime picked = await showDatePicker(
        context: ctx,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      this.dateofBirthController.text =
          "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
      _dateOfBirth.value = "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
    }
  }

  setPageIndex(int index) {
    print("page index $index");
    this._currentPage.value = index;
  }

  int get getCurrentPage => this._currentPage.value;
  String get userName => userNameController.text;
  String get password => passwordController.text;
  String get email => emailController.text;
  String get phone => phoneControlller.text;
  String get nickname => nickNameController.text;
  bool get isMale => this._isMale.value;
  bool get isFemale => this._isFemale.value;
  bool get isOther => this._isOther.value;
  bool get validateType => this._validateType.value;
  bool get isPasswordValid => this._isPasswordVaild.value;
  bool get isUsernameValid => this._isUsernameVaild.value;
  bool get isVerify => this._isVerify.value;
  bool get isEmailValid => this._isEmailVaild.value;
  String get dateOfBirth => this._dateOfBirth.value;
  String get avatarPath => this._avatarPath.value;
  String get gender => this._gender.value;

  checkPasswordVaild(String value) =>
      this._isPasswordVaild.value = (Validators.isValidPassword(password));

  checkUsernameVaild(String value) =>
      this._isUsernameVaild.value = Validators.isVaildUsername(userName);
  checkEmailVaild(String value) => this._isEmailVaild.value = Validators.isValidEmail(value);

  changeValidateType(bool b) => this._validateType.value = b;

  bool get checkGenderSelected => this._gender.value != "";
  bool get checkBirthDay => this._dateOfBirth.value != "";

  void navigate(int index) {
    if (getCurrentPage <= 0) {
      onExit();
    }
    //back
    else if (getCurrentPage > index - 1) {
      pageController.animateToPage(getCurrentPage - 1,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      setPageIndex(getCurrentPage - 1);
    }
    // to
    else {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      setPageIndex(index);
    }
  }

  Future checkUNAvailability(String username) async {}

  void genderSelected(String type, bool value) {
    switch (type) {
      case "male":
        _isMale.value = value;
        _isFemale.value = false;
        this._isOther.value = false;
        this._gender.value = "male";
        break;
      case "female":
        _isFemale.value = value;
        this._isOther.value = false;
        _isMale.value = false;
        this._gender.value = "female";
        break;
      default:
        this._isOther.value = value;
        _isMale.value = false;
        _isFemale.value = false;
        this._gender.value = "other";
    }
  }

  void checkBirthday() {
    if (dateofBirthController.text == "") {
      return null;
    }

    navigate(1);
  }

  void checkGender() {
    navigate(2);
  }

  void checkUserName() {
    navigate(3);
  }

  void checkPassword() {
    navigate(4);
  }

  Future selectAvatar() async {
    try {
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      this._avatarPath.value = image.path;
    } catch (e) {}
  }

  void removeImage() {
    this._avatarPath.value = "";
  }

  Future createAccount(BuildContext context) async {
    print("$dateOfBirth $email $gender $password $userName");

    Get.dialog(Center(
        child: Container(
      height: 100,
      width: 100,
      color: Colors.black,
      child: AppConstraint.loadingIndicator(context),
    )));
    // var result = await SubRepo.mutationGraphQL(await getToken(), mutation.register(nickname, password, userName)).whenComplete(() => Get.isDialogOpen ? Get.back() : null);

    // check is OK

    // set token

    // go to home
  }

  Future onExit() async {
    return Get.defaultDialog(
      radius: 10,
      backgroundColor: Colors.black,
      title: "Register ?",
      middleText: "Are you sure you want to cancel register ?",
      actions: [
        RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel")),
        RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              clear();
              Get.offAllNamed('/');
            },
            child: Text("OK")),
      ],
    );
  }

  void clearInfo(BuildContext ctx, bool value) {
    phoneControlller.clear();
    emailController.clear();
    FocusScope.of(ctx).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    changeValidateType(value);
  }

  void clear() {
    dateofBirthController.clear();
    userNameController.clear();
    passwordController.clear();
    emailController.clear();
    passwordController.clear();
    nickNameController.clear();
    _isMale.value = false;
    _isFemale.value = false;
    _isOther.value = false;
    _currentPage.value = 0;
    _avatarPath.value = "";
    _gender.value = "";
  }
}
