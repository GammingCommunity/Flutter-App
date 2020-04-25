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

  static chatImage(String groupID, String imagePath) async {
    var httpLink = "https://image-service.glitch.me/chat-image/$groupID";

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(httpLink),
    )..files.add(await http.MultipartFile.fromPath("image", imagePath));

    var res = await request.send();
    return res;
  }

  static editGroupImage(String type, String roomID, String imagePath) async {
    if (type == "bg") {
      var httpLink = "https://image-service.glitch.me/edit-room/$roomID/bg";

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(httpLink),
        )..files.add(await http.MultipartFile.fromPath("image", imagePath));
        var response = await request.send();

        if (response.statusCode == 200) {
          var result = await response.stream.bytesToString();
          Map valueMap = json.decode(result);
          return valueMap['url'];
        } else
          return "";
      } catch (e) {
        print(e);
        return "";
      }
    } else {
      var httpLink = "https://image-service.glitch.me/edit-room/$roomID/logo";

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(httpLink),
        )..files.add(await http.MultipartFile.fromPath("image", imagePath));
        var response = await request.send();

        if (response.statusCode == 200) {
          var result = await response.stream.bytesToString();
          Map valueMap = json.decode(result);
          return valueMap['url'];
        } else
          return "";
      } catch (e) {
        print(e);
        return "";
      }
    }
  }
}
