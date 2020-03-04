part of 'room_manager_bloc.dart';

abstract class RoomManagerEvent extends Equatable {
  const RoomManagerEvent();
}
class EditRoom extends RoomManagerEvent{
  final String token;
  final String currentID;
  final String roomName;
  final List<String> member;
  final bool private;

  EditRoom({this.token,this.currentID,this.roomName,this.member,this.private});
  @override
  List<Object> get props => [roomName,member,private];
}
class RemoveRoom extends RoomManagerEvent{

  final String token,currentID,roomID;
  RemoveRoom({this.token,this.currentID,this.roomID});

  @override
  List<Object> get props => [token,currentID,roomID];
}