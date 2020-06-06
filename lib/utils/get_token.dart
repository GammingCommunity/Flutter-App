import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async{
  SharedPreferences ref = await SharedPreferences.getInstance();
  return ref.getString("userToken");
}
Future<Map<String,dynamic>> getUserInfo() async{
  SharedPreferences ref = await SharedPreferences.getInstance();
  Map<String,dynamic> userInfo = {
    "userID":ref.getString("userID"),
    "userName":ref.getString("userName"),
    "profileUrl":ref.getString("userProfile")
  };
  return userInfo;
}