import 'package:http/http.dart' as http;

Future<bool> checkConnection() async {
  try {
    var result = await http.get("https://google.com");
    if (result.statusCode == 200) return true;
    return false;
  } catch (e) {
    return false;
  }
}
