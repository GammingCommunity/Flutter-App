part of 'room_manager_bloc.dart';

abstract class RoomManagerEvent extends Equatable {
  const RoomManagerEvent();
}

class InitLoading extends RoomManagerEvent {
  @override
  List<Object> get props => [];
}

class RefreshRooms extends RoomManagerEvent{
  @override
  List<Object> get props => [];
}

class ModifyRoom extends RoomManagerEvent {
  final String token;
  final String currentID;
  final String roomName;
  final List<String> member;
  final bool private;

  ModifyRoom({this.token, this.currentID, this.roomName, this.member, this.private});
  @override
  List<Object> get props => [roomName, member, private];
}

class RemoveRoom extends RoomManagerEvent {
  final int index;
  RemoveRoom({this.index});

  @override
  List<Object> get props => [index];
}

class AddRoom extends RoomManagerEvent {
  final String hostID;
  final String roomName;
  final String gameID;
  final String gameName;
  final bool isPrivate;
  final bool adminType; // false => free , true => only has permission
  final int numofMember;
  AddRoom(
      {this.hostID,
      this.roomName,
      this.gameID,
      this.gameName,
      this.isPrivate,
      this.adminType,
      this.numofMember});
  @override
  List<Object> get props => [hostID, gameID, gameName, isPrivate, adminType, numofMember];
}
