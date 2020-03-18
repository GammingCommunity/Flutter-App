import 'package:gamming_community/view/room_manager/getUser.dart';
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

class ListRoom {
 
  static Future<List<Room>> getList(List json) async{
    var _listRoom= <Room>[];
    try {
      for (var item in json) {
        var listInt = List<int>.from(item['member'].map((e)=>int.parse(e)).toList());
        var listUser = await getUser(listInt);
        _listRoom.add(Room(
            id: item['_id'],
            hostID: item['hostID'],
            roomName: item['roomName'],
            gameInfo: item['game'] ??= item['game'],
            isPrivate: item['isPrivate'],
            maxOfMember: item['maxOfMember'],
            memberID: listUser,
            createAt: item['createAt']));
      }
      
    } catch (e) {
      print(e);
      return [];
    }
      return _listRoom;
  }
  List<Room> listRoom;
  ListRoom({this.listRoom});
}