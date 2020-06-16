import 'package:gamming_community/utils/enum/messageEnum.dart';

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
                fileInfo: FileInfo(
                    fileName: e['text']['fileInfo']['fileName'],
                    fileSize: e['text']['fileInfo']['fileSize'],
                    publicID: e['text']['fileInfo']['publicID'],
                    height: e['text']['fileInfo']['height'],
                    width: e['text']['fileInfo']['width'])),
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
  FileInfo fileInfo;
  TextMessage({this.content, this.fileInfo});
}

class FileInfo {
  String publicID;
  String fileName;
  String fileSize;
  int height ;
  int width ;

  FileInfo(
      {this.publicID = "",
      this.fileName = "",
      this.fileSize = "",
      this.height = 0,
      this.width = 0});
}

class PrivateConservations {
  List<Conservation> conservations;
  PrivateConservations({this.conservations});
  factory PrivateConservations.fromJson(List json) {
    List<Conservation> _listConservation = [];
    try {
      for (var e in json) {
        String messageType = e['latest_message']['messageType'];
        List<Message> _listMesasge = [];

        _listConservation.add(messageType == MessageEnum.url
            ? Conservation(
                conservationID: e["_id"],
                latestMessage: Message(
                    sender: e['latest_message']['id'],
                    status: e['latest_message']['status'],
                    messageType: messageType,
                    createAt: DateTime.parse(e['latest_message']['createAt']).toLocal(),
                    txtMessage: TextMessage(
                        content: e['latest_message']['text']['content'], fileInfo: FileInfo())))
            : Conservation(
                conservationID: e["_id"],
                member: e['member'],
                latestMessage: Message(
                  sender: e['latest_message']['id'],
                  status: e['latest_message']['status'],
                  txtMessage: TextMessage(
                      content: e['latest_message']['text']['content'],
                      fileInfo: FileInfo(
                          fileName: e['latest_message']['text']['fileInfo']['fileName'],
                          fileSize: e['latest_message']['text']['fileInfo']['fileSize'],
                          publicID: e['latest_message']['text']['fileInfo']['publicID'],
                          height: e['latest_message']['text']['fileInfo']['height'],
                          width: e['latest_message']['text']['fileInfo']['width'])),
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
