import 'dart:io';

import 'package:flutter/material.dart';

class ChangeProfile with ChangeNotifier{
  File _file;
  bool changeAvatar= false;
  get getFile=> _file;
  get isChangeAvatar => changeAvatar;

  void setFilePath(File file) {

    _file=file;
    changeAvatar= true;
    print("File"+file.path);
    print("is change avatar"+ changeAvatar.toString());
    notifyListeners();
  }
}