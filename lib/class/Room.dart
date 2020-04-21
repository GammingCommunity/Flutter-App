class Room {
  String id;
  String roomName;
  String hostID;
  String description;
  String password;
  List memberID;
  int maxOfMember;
  bool isPrivate;
  Map gameInfo;
  String createAt;
  Room(
      {this.id,
      this.roomName,
      this.hostID,
      this.memberID,
      this.gameInfo,
      this.maxOfMember,
      this.isPrivate,
      this.createAt});
}

class Rooms {
  
  List<Room> rooms;
  Rooms({this.rooms});
  factory Rooms.fromJson(List json) {
    var _listRoom = <Room>[];
    try {
      for (var item in json) {
        // var listInt = List<int>.from(item['member'].map((e)=>int.parse(e)).toList());
        // var listUser = await getUser(listInt);
        _listRoom.add(Room(
            id: item['_id'],
            hostID: item['hostID'],
            roomName: item['roomName'],
            gameInfo: item['game'] ??= item['game'],
            isPrivate: item['isPrivate'],
            maxOfMember: item['maxOfMember'],
            memberID: item['member'],
            createAt: item['createAt']));
      }
    } catch (e) {
      print(e);
    }
    return Rooms(rooms: _listRoom);
  }
}
