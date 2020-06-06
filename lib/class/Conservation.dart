class Conservation {
  String conservationID;
  List member;
  Message latestMessage;
  List<Message> message;

  Conservation({this.conservationID, this.member, this.message, this.latestMessage});
}

class Message {
  String sender;
  String messageType;
  String status;
  TextMessage txtMessage;
  DateTime createAt;
  Message({this.sender, this.messageType, this.status, this.createAt, this.txtMessage});
}

class Messages {
  List<Message> messages;
  Messages({this.messages});
  factory Messages.fromJson(List json) {
    var messages = <Message>[];
    try {
      for (var e in json) {
        messages.add(Message(
            sender: e['id'],
            status: e['status'],
            txtMessage: TextMessage(
                content: e['text']['content'],
                height: e['text']['height'],
                width: e['text']['width']),
            messageType: e['messageType'],
            createAt: DateTime.parse(e['createAt']).toLocal()));
      }
    } catch (e) {
      print(e);
      return Messages(messages: []);
    }
    return Messages(messages: messages);
  }
}

class TextMessage {
  String content;
  int height;
  int width;
  TextMessage({this.content, this.height, this.width});
}

class PrivateConservations {
  List<Conservation> conservations;
  PrivateConservations({this.conservations});
  factory PrivateConservations.fromJson(List json) {
    List<Conservation> _listConservation = [];
    try {
      for (var e in json) {
        List<Message> _listMesasge = [];

        _listConservation.add(Conservation(
          conservationID: e["_id"],
          member: e['member'],
          latestMessage: Message(
            sender: e['latest_message']['id'],
            status: e['latest_message']['status'],
            txtMessage: TextMessage(
                content: e['latest_message']['text']['content'],
                height: e['latest_message']['text']['height'],
                width: e['latest_message']['text']['width']),
            messageType: e['latest_message']['messageType'],
            createAt: DateTime.parse(e['latest_message']['createAt']).toLocal(),
          ),
          message: _listMesasge,
        ));
      }
    } catch (e) {
      print(e);
      return PrivateConservations(conservations: []);
    }
    return PrivateConservations(conservations: _listConservation);
  }
}
