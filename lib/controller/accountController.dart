import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountController extends GetxController {
  @override
  void onInit() {
    Get.putAsync<SharedPreferences>(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("isEng", true);
      return prefs;
    });
    super.onInit();
  }
}
