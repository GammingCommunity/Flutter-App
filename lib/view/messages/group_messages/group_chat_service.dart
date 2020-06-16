import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';

class GroupChatService{
  static textMessage(String roomID,String currentID,String text){
    return [
          {
            "groupID": roomID,
          },
          {
            "messageType": "text",
            "sender": currentID,
            "text": {
              "content":text,
            },
          }
        ];
  }
  static mediaMessage(String roomID,String currentID,String url,String messageType, FileInfo fileInfo){
    return [
          {
            "groupID": roomID,
          },
          {
            "messageType": messageType,
            "sender": currentID,
            "text": {
              "content":url,
              "media":fileInfo
            },
          }
        ];
  }
  static addToCache(Message message){
    
  }
}