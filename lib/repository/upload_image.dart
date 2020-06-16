import 'dart:io';
import 'package:gamming_community/utils/get_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class ImageService {
  static fetchImageGroup(String groupID) async {
    var httpLink = "https://image-service.glitch.me/fetch-image/$groupID";
    var result =
        await http.get(httpLink, headers: {HttpHeaders.authorizationHeader: await getToken()});
    print(result);
  }

  static Future changeAvatar()async{
    
  }

  static Future chatMedia(String type,String id, String imagePath) async {
    var httpLink = "https://file-management.glitch.me/chat-media/$type/$id";

    var request = http.MultipartRequest(
      'POST',

      Uri.parse(httpLink),
    )..fields['receive_id'] = id
    ..headers['token']=await getToken()
    ..files.add(await http.MultipartFile.fromPath("media", imagePath));

    var res = await request.send();
    return res;
  }
  static Future chatFile(String type,String id,String filePath)async{
    var httpLink = "https://file-management.glitch.me/chat-file/$type/$id";

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(httpLink),
    )..fields['receive_id'] = id
    ..files.add(await http.MultipartFile.fromPath("files", filePath));

    var res = await request.send();
    return res;
  }

  static editGroupImage(String type, String roomID, String imagePath) async {
    if (type == "cover") {
      var httpLink = "https://file-management.glitch.me/edit-room/cover/$roomID";

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(httpLink),
        )..files.add(await http.MultipartFile.fromPath("image", imagePath));
        var response = await request.send();

        if (response.statusCode == 200) {
          var result = await response.stream.bytesToString();
          Map valueMap = json.decode(result);
          return valueMap['data'];
        } else
          return "";
      } catch (e) {
        print(e);
        return "";
      }
    } else {
      var httpLink = "https://file-management.glitch.me/edit-room/profile/$roomID";

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(httpLink),
        )..files.add(await http.MultipartFile.fromPath("image", imagePath));
        var response = await request.send();

        if (response.statusCode == 200) {
          var result = await response.stream.bytesToString();
          Map valueMap = json.decode(result);
          return valueMap['data'];
        } else
          return "";
      } catch (e) {
        print(e);
        return "";
      }
    }
  }
}
