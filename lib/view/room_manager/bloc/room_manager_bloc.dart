import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/CRUD.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:hive/hive.dart';
part 'room_manager_event.dart';
part 'room_manager_state.dart';

class RoomManagerBloc extends Bloc<RoomManagerEvent, RoomManagerState> {
  var query = GraphQLQuery();
  var mutation = GraphQLMutation();
  List<GroupChat> room = [];
  Box<GroupChatAdapter> groupChatBox;
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
        var rooms = GroupChats.fromJson(result.data).rooms;
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
        var rooms = GroupChats.fromJson(result.data['roomManager']).rooms;
        room.addAll(rooms);
        yield InitSuccess();
      } catch (e) {
        yield InitFail();
      }
    }

    if (event is AddRoom) {
      yield AddRoomLoading();
      try {
        //TODO: let user change logo and background in create room page, now set default
        var result = await MainRepo.mutationGraphQL(
            await getToken(),
            mutation.addRoom(
                info['userID'],
                event.roomName,
                event.isPrivate,
                event.numofMember,
                event.gameID,
                event.gameName,
                AppConstraint.default_logo,
                AppConstraint.default_background));
        var roomID = CRUD.fromJson(result.data['createRoom']).payload;
        var listMember = [];
        listMember.add(info['userID']);
        room.add(GroupChat(
            id: roomID,
            createAt: DateTime.now().toString(),
            gameInfo: GameInfo(
                gameID: event.gameID,
                gameName: event.gameName), // {"gameID": event.gameID, "gameName": event.gameName},
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

    if (event is ModifyRoom) {}
    if (event is RemoveRoom) {
      try {
        //TODO : show notify confirm delete
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
