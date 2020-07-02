import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/CRUD.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/file_upload_repo.dart';
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
  List<User> users = [];
  String currentID = "";
  String avatarPath = "";
  String coverPath = "";
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
        var result = await MainRepo.queryGraphQL(await getToken(), query.getRoomCurrentUser());
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
        var userInfo = await getUserInfo();
        var result = await MainRepo.queryGraphQL(await getToken(), query.getRoomCurrentUser());

        var rooms = GroupChats.fromJson(result.data['roomManager']).rooms;
        this.currentID = userInfo['userID'];
        room.addAll(rooms);
        yield InitSuccess();
      } catch (e) {
        print(e);
        yield InitFail();
      }
    }
    if (event is AddMember) {
      yield AddMemberDialog();
      try {
        users.addAll(event.user);
        yield AddMemberSuccess();
        //var result = await SubRepo.queryGraphQL(await getToken(), query.searchFriend(""));
      } catch (e) {}
    }

    if (event is RemoveMember) {
      try {
        users.removeWhere((e) => e.id == event.id);
        yield RemoveMemberSuccess();
        //var result = await SubRepo.queryGraphQL(await getToken(), query.searchFriend(""));
      } catch (e) {}
    }

    if (event is SetAvatar) {
      try {
        this.avatarPath = event.path;
        yield SetAvatarSuccess();
        //var result = await SubRepo.queryGraphQL(await getToken(), query.searchFriend(""));
      } catch (e) {}
    }
    if (event is UnsetAvatar) {
      try {
        this.avatarPath = "";
        yield UnsetAvatarSuccess();
        //var result = await SubRepo.queryGraphQL(await getToken(), query.searchFriend(""));
      } catch (e) {}
    }

    if (event is SetCover) {
      try {
        this.coverPath = event.path;
        yield SetCoverSuccess();
        //var result = await SubRepo.queryGraphQL(await getToken(), query.searchFriend(""));
      } catch (e) {}
    }
    if (event is UnsetCover) {
      try {
        this.coverPath = "";
        yield UnSetCoverSuccess();
        //var result = await SubRepo.queryGraphQL(await getToken(), query.searchFriend(""));
      } catch (e) {}
    }

    if (event is AddRoom) {
      yield AddRoomLoading();
      try {
        var result = await MainRepo.mutationGraphQL(
            await getToken(),
            mutation.addRoom(
                info['userID'],
                event.roomName,
                event.roomType,
                event.numofMember,
                event.gameID,
                json.encode(event.member),
                AppConstraint.default_logo,
                AppConstraint.default_background,event.adminType));
        var groupID = CRUD.fromJson(result.data['createRoom']).payload;

        // upload and update room cover and avatar
        if (event.avatarPath == "" && event.coverPath == "") {
        } else {
          var urls =
              await FileUploadRepo.uploadCoverAndAvtar(groupID, event.avatarPath, event.coverPath);
          //print(urls['avatar'],urls['cover']);

          // update data
          var updateRoom =
              await MainRepo.mutationGraphQL(await getToken(), mutation.changeGroupImage(groupID: groupID,avatar: urls['avatar'],cover: urls['cover']));
           
          if(CRUD.fromJson(updateRoom.data['changeGroupImage']).statusCode == 200)
          {
            var listMember = [];
            listMember.add(info['userID']);
            listMember.addAll(event.member);
            room.add(GroupChat(
                id: groupID,
                createAt: DateTime.now().toString(),
                gameInfo: GameInfo(
                    gameID: event.gameID,
                    gameName: ""), // {"gameID": event.gameID, "gameName": event.gameName},
                hostID: info['userID'],
                maxOfMember: event.numofMember,
                memberID: listMember,
                roomLogo: urls['avatar'],
                roomBackground: urls['cover'],
                roomName: event.roomName));
            yield AddRoomSuccess();
          }
        
          
        }
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
