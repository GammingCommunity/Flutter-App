import 'package:http/http.dart' as http;
Future<bool> checkConnection()async{
  try {
    var result = await http.get("https://google.com");
    return true;
  } catch (e) {
    return false;
  }
}