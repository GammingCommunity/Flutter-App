import 'package:gamming_community/view/profile/profileController.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBinding extends Bindings {
  @override
  dependencies() {
    Get.putAsync<SharedPreferences>(() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs;
    }, permanent: true);
    Get.put<ProfileController>(ProfileController());
  }
}
