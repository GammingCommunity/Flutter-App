class GroupMessage {
  String type;
  String messageID;
  String text;
  String sender;
  DateTime createAt;
  GroupMessage({this.type,this.messageID, this.text, this.sender, this.createAt});
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
                sender: e['userID'],
                createAt: e['createAt'],
                text: e['text']))
          });
    } catch (e) {
      print(e);
      return GroupMessages(groupMessages: []);
    }
    return GroupMessages(groupMessages: _listGroupMessage);
  }
}
