import 'package:flutter/material.dart';

class SetRoomBackground with ChangeNotifier{
  bool isRoomNameEmpty = false;
  void roomNameSate (bool state) {
    isRoomNameEmpty= state;
    notifyListeners();
  }
  bool get checkroomName => isRoomNameEmpty;
}