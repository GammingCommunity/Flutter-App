import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/CRUD.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/room_manager/room_manager.dart';
import 'package:intl/intl.dart';
part 'room_manager_event.dart';
part 'room_manager_state.dart';

class RoomManagerBloc extends Bloc<RoomManagerEvent, RoomManagerState> {
  var query = GraphQLQuery();
  var mutation = GraphQLMutation();
  List<Room> room = [];

  @override
  RoomManagerState get initialState => RoomManagerInitial();

  @override
  Stream<RoomManagerState> mapEventToState(
    RoomManagerEvent event,
  ) async* {
    var info = await getUserInfo();

    if (event is RefreshRooms) {
      room.clear();
      try {
        var result =
            await MainRepo.queryGraphQL(await getToken(), query.getRoomCurrentUser(info['userID']));
        var rooms = Rooms.fromJson(result.data['roomManage']).rooms;
        print("on refresh");
        room.addAll(rooms);
        yield RefreshSuccess();
      } catch (e) {
        yield RefreshFail();
      }
    }

    if (event is InitLoading) {
      try {
        var result =
            await MainRepo.queryGraphQL(await getToken(), query.getRoomCurrentUser(info['userID']));
        var rooms = Rooms.fromJson(result.data['roomManage']).rooms;
        room.addAll(rooms);
        yield InitSuccess();
      } catch (e) {
        yield InitFail();
      }
    }

    if (event is AddRoom) {
      yield AddRoomLoading();
      try {
        var result = await MainRepo.mutationGraphQL(
            await getToken(),
            mutation.addRoom(info['userID'], event.roomName, event.isPrivate, event.numofMember,
                event.gameID, event.gameName));
        var roomID = CRUD.fromJson(result.data['createRoom']).payload;
        var listMember = [];
        listMember.add(info['userID']);
        room.add(Room(
            id: roomID,
            createAt: DateTime.now().toString(),
            gameInfo: {"gameID": event.gameID, "gameName": event.gameName},
            hostID: info['userID'],
            isPrivate: event.isPrivate,
            maxOfMember: event.numofMember,
            memberID: listMember,
            roomName: event.roomName));
        print(room);
        yield AddRoomSuccess();
      } catch (e) {
        print(e);
        yield AddRoomFail();
      }
    }

    if (event is EditRoom) {}
    if (event is RemoveRoom) {
      try {
        var result = await MainRepo.mutationGraphQL(
            await getToken(), mutation.removeRoom(room[event.index].id, info['userID']));
        var respond = CRUD.fromJson(result.data['removeRoom']);
        if (respond.statusCode == 200) {
          yield RemoveRoomSuccess();
          room.removeAt(event.index);
        }
        yield RemoveRoomFailed();
      } catch (e) {
        print(e);
        yield RemoveRoomFailed();
      }
      
    }
  }
}
