import 'package:flutter/material.dart';

class FriendActive with ChangeNotifier{
  bool isActive =false;
  void setFriendActive(bool state){
    isActive =state;
    notifyListeners();
  }
}