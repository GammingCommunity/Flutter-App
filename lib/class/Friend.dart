class Friend {
  int id;
  String name;
  String profileUrl;

  Friend({this.id, this.name, this.profileUrl});
}

class ListFriends {
  List<Friend> listFriend;
  ListFriends({this.listFriend});
  factory ListFriends.fromJson(List json) {
    var _listFriend = <Friend>[];
    try {
      json.forEach((e) {
        _listFriend.add(Friend(
            id: e['friend']['id'],
            name: e['friend']['name'],
            profileUrl: e['friend']['avatar_url']));
      });

    } catch (e) {
      print(e);
      return ListFriends(listFriend: []);
    }
    return ListFriends(listFriend: _listFriend);
  }
}
