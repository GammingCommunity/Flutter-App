import 'package:flutter/material.dart';

class NotificationModel with ChangeNotifier{
  bool seeNotify = false;
  void seen(bool clicked){
     seeNotify =clicked;
     notifyListeners();
  }
  get isSeen => seeNotify;

  
}