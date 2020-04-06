import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ImageService{
  
  static fetchImageGroup(String groupID)async{
    SharedPreferences ref = await SharedPreferences.getInstance();
    String userToken =ref.getStringList("userToken")[2];
    var httpLink ="http://image-service.glitch.me/fetch-image/${groupID}";
    var result = await http.get(httpLink,headers: {
      HttpHeaders.authorizationHeader:userToken
    });
    print(result);
  } 
  static chatImage(String groupID,String imagePath) async{
    SharedPreferences ref = await SharedPreferences.getInstance();
    String userToken =ref.getStringList("userToken")[2];
    var httpLink ="http://image-service.glitch.me/chat-image/$groupID";
    
    var request = http.MultipartRequest('POST', Uri.parse(httpLink))
        ..files.add(await http.MultipartFile.fromPath("image", imagePath));
    var res = await request.send();
    return res;

    
  }
}