import 'dart:convert';

import 'package:gamming_community/class/GroupMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{

  Future<bool> checkDataExist(String key) async {
     SharedPreferences ref =await SharedPreferences.getInstance();
    
    return ref.containsKey(key);
  }

  Future<List<GroupMessage>> readfromCache() async{
    SharedPreferences ref =await SharedPreferences.getInstance();
    var listMessage = ref.getStringList("listMessage")[1];
    var toObject= GroupMessages.listFromJson(json.decode(listMessage));
   return toObject.groupMessages;
  }
  
  void saveToCache(List<GroupMessage> groupMessage) async{
    SharedPreferences ref =await SharedPreferences.getInstance();
    var newData=  json.encode(groupMessage);
    var now=  DateTime.now().toUtc().toString();
    ref.setStringList("listMessage",[now,newData]);
  }

  void clear() async{
    SharedPreferences ref =await SharedPreferences.getInstance();
    ref.remove("listMessage");

  }
}