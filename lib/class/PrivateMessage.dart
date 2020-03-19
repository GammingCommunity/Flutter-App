import 'package:flutter/widgets.dart';
import 'package:gamming_community/view/messages/chat_message.dart';

class PrivateMessage {
  Map<String, dynamic> sender;
  String text, userID;
  DateTime createAt;
  PrivateMessage({this.sender, this.userID, this.createAt, this.text});
}

class PrivateMessages {
  List<ChatMessage> privateMessages;
  
  PrivateMessages({this.privateMessages});
  factory PrivateMessages.fromJson(List json,AnimationController controller) {
    var _listPrivateMessage = <ChatMessage>[]; 
    try {
      for (var item in json) {
        item['messages'].forEach((e) => {
              _listPrivateMessage.add(ChatMessage(
                
                animationController: controller,
                text: e['text'],
                sendDate: DateTime.parse(e['createAt']),
                sender: e['user']
              ))
              
            });
      }
    } catch (e) {
      print(e);
      return PrivateMessages(privateMessages: []);
    }
    return PrivateMessages(privateMessages: _listPrivateMessage);
  }
}
