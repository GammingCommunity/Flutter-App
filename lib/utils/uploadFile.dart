import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert' show json, utf8;

uploadFile(String userID, File imagePath) async {
  print("image path"+ imagePath.path);
  var postUri = Uri.parse('https://profile-services.glitch.me/upload-avatar');
  var request = new http.MultipartRequest("POST", postUri);
  request.fields['profile_id'] = userID;
  request.files.add(await http.MultipartFile.fromPath(
      'profile_image', imagePath.path));
  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      Map valueMap = json.decode(result);
      print(valueMap);
      return valueMap['image_url'];
    }
    else return "";
      
  } catch (e) {
    print(e);
    return "";
  }
}
