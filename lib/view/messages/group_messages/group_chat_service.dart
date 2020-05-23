import 'package:gamming_community/class/Conservation.dart';

class GroupChatService{
  static textMessage(String roomID,String currentID,String text){
    return [
          {
            "groupID": roomID,
          },
          {
            "messageType": "text",
            "id": currentID,
            "text": {
              "content":text,
              "height":0,
              "width":0
            },
          }
        ];
  }
  static mediaMessage(String roomID,String currentID,String url,int height,int width){
    return [
          {
            "groupID": roomID,
          },
          {
            "messageType": "media",
            "id": currentID,
            "text": {
              "content":url,
              "height":height,
              "width":width
            },
          }
        ];
  }
  static addToCache(Message message){
    
  }
}