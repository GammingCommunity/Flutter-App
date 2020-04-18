class GroupMessage {
  String type;
  String messageID;
  GMessage text;
  String sender;
  DateTime createAt;
  GroupMessage({this.type, this.messageID, this.text, this.sender, this.createAt});
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "messageID": messageID,
      "text": text,
      "sender": sender,
      "createAt": createAt.toString()
    };
  }
}

class GMessage {
  String content;
  int height, width;
  GMessage({this.content, this.height, this.width});
  factory GMessage.fromMap(Map<String, dynamic> text) {
    return GMessage(content: text['content'], height: text['height'], width: text['width']);
  }
  Map<String,dynamic> toJson(){
    return {
      "content":content,
      "height":height,
      "width":width
    };
  }
}

class GroupMessages {
  List<GroupMessage> groupMessages;
  GroupMessages({this.groupMessages});
  List toJson(){
    return [GroupMessage()];
   
  }
  factory GroupMessages.mapFromJson(Map json) {
    var _listGroupMessage = <GroupMessage>[];
    try {
      var messages = json['getRoomMessage']['messages'];

      messages.forEach((e) => {
            _listGroupMessage.add(GroupMessage(
                type: e['messageType'],
                messageID: e['_id'],
                sender: e['id'],
                createAt: DateTime.parse(e['createAt']),
                text: GMessage.fromMap(e['text'])))
          });
    } catch (e) {
      print(e);
      return GroupMessages(groupMessages: []);
    }
    return GroupMessages(groupMessages: _listGroupMessage);
  }
  factory GroupMessages.listFromJson(List json){
    var _listGroupMessage = <GroupMessage>[];

    try {
      json.forEach((e) => {
            _listGroupMessage.add(GroupMessage(
                type: e['type'],
                messageID: e['messageID'],
                sender: e['sender'],
                createAt: DateTime.parse(e['createAt']),
                text: GMessage.fromMap(e['text'])))
          });
    } catch (e) {
      return  GroupMessages(groupMessages: []);
    }
  return GroupMessages(groupMessages: _listGroupMessage);
  }
}
