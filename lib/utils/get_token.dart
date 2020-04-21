import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async{
  SharedPreferences ref = await SharedPreferences.getInstance();
  return ref.getStringList("userToken")[2];
}