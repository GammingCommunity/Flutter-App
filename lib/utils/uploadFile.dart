import 'dart:io';
import 'package:gamming_community/utils/get_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

Future<bool> uploadFile(String userID, File imagePath) async {
  //print("image path"+ imagePath.path);
  var postUri = Uri.parse('https://file-management.glitch.me/change-avatar');
  var request = new http.MultipartRequest("POST", postUri);
  request.fields['token'] = await getToken();
  request.files.add(await http.MultipartFile.fromPath('image', imagePath.path));
  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      /*var result = await response.stream.bytesToString();
      Map valueMap = json.decode(result);
      return valueMap['image_url'];*/
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
