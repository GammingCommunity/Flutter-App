class Room {
  String id;
  String roomName;
  String hostID;
  String description;
  String password;
  List memberID;
  int maxOfMember;
  bool isPrivate;
  GameInfo gameInfo;
  String createAt;
  String roomLogo;
  String roomBackground;
  bool isJoin;
  bool isRequest;
  Room(
      {this.id,
      this.roomName,
      this.hostID,
      this.memberID,
      this.gameInfo,
      this.maxOfMember,
      this.isPrivate,
      this.roomLogo,
      this.roomBackground,
      this.isJoin,
      this.isRequest,
      this.createAt});
  factory Room.fromJson(Map json) {
    return Room(
        id: json['_id'],
        hostID: json['hostID'],
        roomName: json['roomName'],
        gameInfo: GameInfo(gameID: json['game']['gameID'], gameName: json['game']['gameName']),
        isPrivate: json['isPrivate'],
        maxOfMember: json['maxOfMember'],
        memberID: json['member'],
        createAt: json['createAt'],
        roomLogo: json['roomLogo'],
        roomBackground: json['roomBackground'],
        isJoin: json['isJoin'],
        isRequest: json['isRequest']
        
        );
  }
}

class GameInfo {
  String gameID;
  String gameName;
  GameInfo({this.gameID, this.gameName});
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
            gameInfo: item['game'] == null
                ? GameInfo()
                : GameInfo(gameID: item['game']['gameID'], gameName: item['game']['gameName']),
            //gameInfo: item['game'] ??= item['game'],
            isPrivate: item['isPrivate'],
            maxOfMember: item['maxOfMember'],
            memberID: item['member'],
            createAt: item['createAt'],
            roomBackground: item['roomBackground'],
            roomLogo: item['roomLogo'],
            isJoin: item['isJoin'],
            isRequest: item['isRequest']
            
            ));
      }
    } catch (e) {
      print(e);
    }
    return Rooms(rooms: _listRoom);
  }
}
