part of 'room_manager_bloc.dart';

abstract class RoomManagerEvent extends Equatable {
  const RoomManagerEvent();
}

class InitLoading extends RoomManagerEvent {
  @override
  List<Object> get props => [];
}

class RefreshRooms extends RoomManagerEvent {
  @override
  List<Object> get props => [];
}

class AddMember extends RoomManagerEvent {
  final List<User> user;
  AddMember({this.user});
  @override
  List<Object> get props => [user];
}

class RemoveMember extends RoomManagerEvent {
  final int id;
  RemoveMember({this.id});
  @override
  List<Object> get props => [id];
}

class SetAvatar extends RoomManagerEvent {
  final String path;
  SetAvatar({this.path});
  @override
  List<Object> get props => [path];
}

class UnsetAvatar extends RoomManagerEvent {
  @override
  List<Object> get props => [];
}

class SetCover extends RoomManagerEvent {
  final String path;
  SetCover({this.path});
  @override
  List<Object> get props => [path];
}

class UnsetCover extends RoomManagerEvent {
  @override
  List<Object> get props => [];
}

class ModifyRoom extends RoomManagerEvent {
  final String token;
  final String currentID;
  final String roomName;
  final List<String> member;
  final String roomType;

  ModifyRoom({this.token, this.currentID, this.roomName, this.member, this.roomType});
  @override
  List<Object> get props => [roomName, member, roomType];
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
  final String roomType;
  final bool adminType; // false => free , true => only has permission
  final int numofMember;
  final String avatarPath;
  final String coverPath;
  final List<String> member;
  AddRoom(
      {this.hostID,
      this.roomName,
      this.gameID,
      this.gameName,
      this.roomType,
      this.adminType,
      this.member,
      this.avatarPath,this.coverPath,
      this.numofMember});
  @override
  List<Object> get props => [hostID, gameID, gameName, roomType, adminType, numofMember,avatarPath,coverPath];
}
