class Conservation {
  Map<String, String> currentUser;
  Map<String, String> friend;
  List<Message> message;
  Conservation({this.currentUser, this.friend, this.message});
}

class Message {
  String sender;
  String text;
  String createAt;
  Message({this.sender, this.text, this.createAt});
}

class PrivateConservations {
  List<Conservation> conservations;
  PrivateConservations({this.conservations});
  factory PrivateConservations.fromJson(List json) {
    List<Conservation> _listConservation = [];
    try {
      json.forEach((e) {
        List<Message> _listMesasge = [];
        for (var item in e['messages']) {
          _listMesasge.add(Message(
              sender: item['user']['id'],
              text: item['text'],
              createAt: item['createAt']));
        }
        _listConservation.add(Conservation(currentUser: {
          "id": e['currentUser']['id'],
          "profileUrl": e['currentUser']['profile_url']
        }, friend: {
          "id": e['friend']['id'],
          "profileUrl": e['friend']['profile_url']
        }, message: _listMesasge));
      });
    } catch (e) {
      print(e);
      return PrivateConservations();
    }
    return PrivateConservations(conservations: _listConservation);
  }
}
