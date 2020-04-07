class GroupMessage {
  String type;
  String messageID;
  GMessage text;
  String sender;
  DateTime createAt;
  GroupMessage({this.type,this.messageID, this.text, this.sender, this.createAt});
}
class GMessage{
  String content;
  int height,width;
  GMessage({this.content,this.height = 0,this.width = 0});
  factory GMessage.fromMap(Map<String,dynamic> text){
    return GMessage(content: text['content'],height: text['height'],width: text['width']);
  }
}
class GroupMessages {
  List<GroupMessage> groupMessages;
  GroupMessages({this.groupMessages});
  factory GroupMessages.fromJson(Map json) {
    var _listGroupMessage = <GroupMessage>[];
    try {
      var messages = json['getRoomMessage']['messages'];
      
      messages.forEach((e) => {
            _listGroupMessage.add(GroupMessage(
              type: e['messageType'],
                messageID: e['_id'],
                sender: e['id'],
                createAt: DateTime.parse(e['createAt']) ,
                text: GMessage.fromMap(e['text'])))
          });
    } catch (e) {
      print(e);
      return GroupMessages(groupMessages: []);
    }
    return GroupMessages(groupMessages: _listGroupMessage);
  }
}
