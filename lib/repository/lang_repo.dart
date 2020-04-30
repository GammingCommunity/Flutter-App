import 'package:shared_preferences/shared_preferences.dart';

class LangRepo {
  
  static Future setLanguage(bool isEng) async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    ref.setBool("isEng", isEng);
   
  }
}
