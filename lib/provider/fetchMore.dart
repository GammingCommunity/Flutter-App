
import 'package:flutter/foundation.dart';
import 'package:gamming_community/class/Room.dart';

class FetchMoreValue with ChangeNotifier{
 List<Room> _listRoom=[];
 void setMoreValue(List<Room> r){
   //print("From model : ${r[0].roomName}");
   _listRoom= r;
   notifyListeners();
 }
 List<Room> get getMoreValue =>_listRoom;

  
}