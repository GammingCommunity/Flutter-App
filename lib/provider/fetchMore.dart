
import 'package:flutter/foundation.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FetchMoreValue with ChangeNotifier{
 List<GroupChat> _listRoom=[];
 bool isFetch= false;
  RefreshController _refreshController= RefreshController();
 void firstLoad(List<GroupChat> r){
  
  try {
    
      print("From model : ${r[0].roomName}");
     _listRoom.addAll(r);

     notifyListeners();
    
   
  } catch (e) {
     noMoreData();
    
  }
 }
 void setMoreValue(List<GroupChat> r){
  //print("From model : ${r[0].roomName}");
  try {
    print("From model : ${_listRoom.length}");
     _listRoom.addAll(r);
      notifyListeners();
  } catch (e) {
    if(r.isEmpty){
      noMoreData();
    }
  }
  
 }
 void clearData(){
   _listRoom.clear();
   notifyListeners();
 }
 void noMoreData(){
  _refreshController.loadNoData();
    notifyListeners();
 }
 List<GroupChat> get getMoreValue =>_listRoom;
  void get noMoreValue => _refreshController.loadNoData();
}