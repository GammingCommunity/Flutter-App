import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  int _currentPage = 0;
  String _gender = "";
  DateTime _dateOfBirth = DateTime.now();
  String _userName = "";
  String _password = "";
  String _email = "";
  int _phone = 0;

  get getPageIndex => _currentPage;
  void setPageIndex(int index) {
    print("page index $index");
    _currentPage = index;
    notifyListeners();
  }

  void setGender(String gender) {
    this._gender = gender;
  }

  void setDateOfBirth(DateTime dateOfBirth) {
    this._dateOfBirth = dateOfBirth;
  }

  void setPassword(String password) {
    this._password = password;
  }

  void setPhone(int phone) {
    this._phone = phone;
  }

  void setUsername(String username) {
    this._userName = username;
  }

  void setAvatar(String avatarPath) {}
  void createAccount() {
    // call bloc
    print("$_dateOfBirth $_email $_gender $_password $_userName");
  }
}
