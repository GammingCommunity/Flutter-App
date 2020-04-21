class JoinRoom{
  String userID;
  String roomName;
  DateTime joinTime;
  bool isApprove;
  JoinRoom({this.isApprove = false,this.joinTime ,this.roomName,this.userID});
  factory JoinRoom.fromJson(Map json){
    try {
      return JoinRoom(
        isApprove: json['isApprove'],
        joinTime: DateTime.parse(json['joinTime']),
        roomName: json['roomName'],
        userID: json['userID']
      );
    } catch (e) {
      return JoinRoom();
    }
  }
}