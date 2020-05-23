import 'package:hive/hive.dart';
part 'GroupMessage.g.dart';

@HiveType(typeId: 1)
class GroupMessage extends HiveObject {
  @HiveField(0)
  String messageType;
  @HiveField(1)
  String messageID;
  @HiveField(2)
  GMessage text;
  @HiveField(3)
  String sender;
  @HiveField(4)
  DateTime createAt;
  GroupMessage({this.messageType, this.messageID, this.text, this.sender, this.createAt});
  Map<String, dynamic> toJson() {
    return {
      "messageType": messageType,
      "messageID": messageID,
      "text": text,
      "sender": sender,
      "createAt": createAt.toString()
    };
  }
}

@HiveType(typeId: 0)
class GMessage extends HiveObject {
  @HiveField(0)
  String content;
  @HiveField(1)
  int height;
  @HiveField(2)
  int width;
  GMessage({this.content, this.height, this.width});
  factory GMessage.fromMap(Map<String, dynamic> text) {
    return GMessage(content: text['content'], height: text['height'], width: text['width']);
  }
  Map<String, dynamic> toJson() {
    return {"content": content, "height": height, "width": width};
  }
}

@HiveType(typeId: 2)
class GroupMessages extends HiveObject {
  @HiveField(0)
  List<GroupMessage> groupMessages;
  GroupMessages({this.groupMessages});
  List toJson() {
    return [GroupMessage()];
  }

  factory GroupMessages.mapFromJson(Map json) {
    var _listGroupMessage = <GroupMessage>[];
    try {
      var messages = json['getRoomMessage']['messages'];

      messages.forEach((e) => {
            _listGroupMessage.add(GroupMessage(
                messageType: e['messageType'],
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

  factory GroupMessages.listFromJson(List json) {
    var _listGroupMessage = <GroupMessage>[];

    try {
      for (var item in json) {
        _listGroupMessage.add(GroupMessage(
            messageType: item['messageType'],
            messageID: item['messageID'],
            sender: item['sender'],
            createAt: DateTime.parse(item['createAt']),
            text: GMessage.fromMap(item['text'])));
      }
    } catch (e) {
      return GroupMessages(groupMessages: []);
    }
    return GroupMessages(groupMessages: _listGroupMessage);
  }
}
