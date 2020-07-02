import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  static SignUpController get to => Get.find();

  ImagePicker imagePicker = ImagePicker();

  var gender = "".obs;
  var currentPage = 0.obs;
  var hasError = false.obs;
  var isPasswordVaild = false.obs;
  var isUsernameVaild = false.obs;
  var isMale = false.obs;
  var isFemale = false.obs;
  var isOther = false.obs;

  var pageController = PageController();
  var dateofBirthController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneControlller = TextEditingController();

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
    }
  }

  setPageIndex(int index) {
    print("page index $index");
    this.currentPage.value = index;
  }

  int get getCurrentPage => this.currentPage.value;
  String get userName => userNameController.text;
  String get password => passwordController.text;
  String get email => emailController.text;
  String get dateOfBirth => dateofBirthController.text;
  String get phone => phoneControlller.text;

  checkPasswordVaild(String value) =>
      this.isPasswordVaild.value = (Validators.isValidPassword(password));

  checkUsernameVaild(String value) =>
      this.isUsernameVaild.value = Validators.isVaildUsername(userName);
  bool get checkGenderSelected => this.gender.value != "";
  bool get checkBirthDay => this.dateofBirthController.text != "";
  void navigate(int index) {
    //back
    if (getCurrentPage > index) {
      pageController.animateToPage(getCurrentPage - 1,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      setPageIndex(getCurrentPage - 1);
    }
    // to
    else if (getCurrentPage < index) {
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
      setPageIndex(index);
    } else if (getCurrentPage == 0) {
      Get.back();
    }
  }

  void genderSelected(String type, bool value) {
    switch (type) {
      case "male":
        isMale.value = value;
        isFemale.value = false;
        this.isOther.value = false;
        this.gender.value = "male";
        break;
      case "female":
        isFemale.value = value;
        this.isOther.value = false;
        isMale.value = false;
        this.gender.value = "female";
        break;
      default:
        this.isOther.value = value;
        isMale.value = false;
        isFemale.value = false;
        this.gender.value = "other";
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
      await imagePicker.getImage(source: ImageSource.gallery);
    } catch (e) {}
  }

  void createAccount() {
    print("$dateOfBirth $email ${gender.value} $password $userName");
  }

  void clear() {}
}
