import 'dart:io';

import 'package:gamming_community/API/URLEndpoint.dart';
import 'package:gamming_community/class/ImageContent.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class FileUploadRepo {
  static var url = URLEndpoint.fileManagerService;

  static Future getMediaUpload(List<PostContent> image) async {
    var httpLink = "$url/user-post";
    var newList = List<http.MultipartFile>();

    try {
      for (var item in image) {
        var multipartFile = await http.MultipartFile.fromPath("media", item.file.path);
        newList.add(multipartFile);
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(httpLink),
      )
        ..headers['token'] = await getToken()
        ..files.addAll(newList);

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
  static Future uploadCoverAndAvtar(String groupID,String avatarPath,String coverPath) async {
    var httpLink = "$url/group-image/$groupID";
    var newList = List<http.MultipartFile>();

    try {
       var multipartCover = await http.MultipartFile.fromPath("avatar", avatarPath);
       var multipartAvatar = await http.MultipartFile.fromPath("cover", coverPath);
        newList..add(multipartCover)..add(multipartAvatar);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(httpLink),
      )
        ..headers['token'] = await getToken()
        ..files.addAll(newList);

      var response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        Map valueMap = json.decode(result);
        return valueMap;
      } else
        return "";
    } catch (e) {
      print(e);
      return "";
    }
  }
}
