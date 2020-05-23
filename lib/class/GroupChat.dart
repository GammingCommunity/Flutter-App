import 'package:hive/hive.dart';
part 'GroupChat.g.dart';
// add to hive db

@HiveType(typeId: 10)
class GroupChat extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  String roomName;
  @HiveField(2)
  String hostID;
  @HiveField(3)
  String description;
  @HiveField(4)
  List memberID;
  @HiveField(5)
  int maxOfMember;
  @HiveField(6)
  bool isPrivate;
  @HiveField(7)
  GameInfo gameInfo;
  @HiveField(8)
  String createAt;
  @HiveField(9)
  String roomLogo;
  @HiveField(10)
  String roomBackground;
  @HiveField(11)
  bool isJoin;
  @HiveField(12)
  bool isRequest;
  GroupChat(
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
  factory GroupChat.fromJson(Map json) {
    return GroupChat(
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
@HiveType(typeId: 11)
class GameInfo extends HiveObject{
  @HiveField(0)
  String gameID;
  @HiveField(1)
  String gameName;
  GameInfo({this.gameID, this.gameName});
}
@HiveType(typeId: 12)
class GroupChats extends HiveObject {
  @HiveField(0)
  List<GroupChat> rooms;
  GroupChats({this.rooms});
  factory GroupChats.fromJson(List json) {
    var _listRoom = <GroupChat>[];
    try {
      for (var item in json) {
        // var listInt = List<int>.from(item['member'].map((e)=>int.parse(e)).toList());
        // var listUser = await getUser(listInt);
        _listRoom.add(GroupChat(
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
    return GroupChats(rooms: _listRoom);
  }
}
