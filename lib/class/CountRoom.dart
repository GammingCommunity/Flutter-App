class Room{
  String id;
  String gameName;
  String background;
  int count;
  Room({this.id,this.gameName,this.background,this.count});

}
class ListNumberOfRoom{
  List<Room> listRoom;
  ListNumberOfRoom({this.listRoom});
  factory ListNumberOfRoom.json(List<dynamic> json){
    List<Room> _listRoom= [];
    try {
      json.forEach((e) {
        _listRoom.add(Room(id: e['_id'],gameName: e['name'],background: e['background'],count: e['count']));
       });
    } catch (e) {
      return ListNumberOfRoom(listRoom: []);
    }
    return ListNumberOfRoom(listRoom: _listRoom);
  }
}