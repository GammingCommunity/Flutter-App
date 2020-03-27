
class PrivateMessage {
  Map<String, dynamic> sender;
  String text;
  DateTime createAt;
  PrivateMessage({this.sender, this.createAt, this.text});
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
                sender: e['user'],
                text: e['text'],
             
              ))
                
               /* ChatMessage(
                animationController: controller,
                text: e['text'],
                sendDate: DateTime.parse(e['createAt']),
                sender: e['user']
              )*/
              
            });
      }
    } catch (e) {
      print(e);
      return PrivateMessages(privateMessages: []);
    }
    return PrivateMessages(privateMessages: _listPrivateMessage);
  }
}
