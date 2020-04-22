part of 'room_manager_bloc.dart';

abstract class RoomManagerState extends Equatable {
  const RoomManagerState();
}

class RoomManagerInitial extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class RefreshSuccess extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class RefreshFail extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class InitSuccess extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class InitFail extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class AddRoomLoading extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class AddRoomSuccess extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class AddRoomFail extends RoomManagerState {
  @override
  List<Object> get props => [];
}


class EditRoomLoading extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class EditRoomSuccess extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class EditRoomFailed extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class RemoveRoomInitial extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class RemoveRoomLoading extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class RemoveRoomSuccess extends RoomManagerState {
  @override
  List<Object> get props => [];
}

class RemoveRoomFailed extends RoomManagerState {
  @override
  List<Object> get props => [];
}
