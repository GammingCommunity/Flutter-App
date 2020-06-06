class PrivateMessage {
  String messageID;
  List memeber;
  DateTime createAt;
  Message message;
  
  PrivateMessage({this.messageID, this.memeber,this.message, this.createAt});
}

class Message {
  String sender;
  String messageType;
  String status;
  MessageDetail text;
  Message({this.sender, this.messageType, this.status, this.text});
}

class MessageDetail {
  String content;
  int height;
  int width;
  MessageDetail({this.content, this.height, this.width});
}

class PrivateMessages {
  List<PrivateMessage> privateMessages;

  PrivateMessages({this.privateMessages});
  factory PrivateMessages.fromJson(List json) {
    var _listPrivateMessage = <PrivateMessage>[];
    try {
      for (var item in json) {
        item['messages'].forEach((e) => {
              _listPrivateMessage.add(PrivateMessage(
                createAt: DateTime.parse(e['createAt']),
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
