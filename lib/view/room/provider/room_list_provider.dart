import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomsProvider extends StatesRebuilder {
  var query = GraphQLQuery();
  bool hasNoValue = false;
  List<GroupChat> _rooms = [];
  String groupSize = "";
  String gameID = "";
  String userID = "";

  int nextPage = 1;
  int limit = 6;

  List<GroupChat> get rooms => _rooms;
  
  /*--------------------------------------------------------------------------------- */

  void setGroupSize(String groupSize) {
    this.groupSize = groupSize;
  }

  /*--------------------------------------------------------------------------------- */
  Future initLoad(String gameID, String groupSize) async {
    this.gameID = gameID;

    var info = await getUserInfo();
    this.userID = info['userID'];

    var room = await queryRoom(gameID, userID, limit, nextPage, groupSize);
    if (room.isEmpty) {
      hasNoValue = true;
      rebuildStates();
    } else {
      _rooms.addAll(room);
      rebuildStates();
    }
  }

/*--------------------------------------------------------------------------------- */
  Future refresh(String type) async {
    clear();
    initLoad(gameID, type);
  }

/*--------------------------------------------------------------------------------- */
  Future<List<GroupChat>> queryRoom(
      String gameID, String userID, int limit, int nextPage, String groupSize) async {
    try {
      var result = await MainRepo.queryGraphQL(
          await getToken(), query.getListRoomByID(gameID, userID, limit, nextPage, groupSize));

      return GroupChats.fromJson(result.data['getRoomByGame']).rooms;
    } catch (e) {
      return [];
    }
  }

/*--------------------------------------------------------------------------------- */
  Future loadMore() async {
    print("load more");
    nextPage += 1;
    var rooms = await queryRoom(gameID, userID, limit, nextPage, groupSize);
    _rooms.addAll(rooms);
    rebuildStates();
  }

  /*--------------------------------------------------------------------------------- */
  Future onRequest(String hostID, String roomID) async {
    var info = await getUserInfo();
    var result = MainRepo.mutateWithVariable(await getToken(), mutation.joinRoom(),
        {"hostID": hostID, "currentID": info['userID'], "roomID": roomID});
    return result;
  }

/*--------------------------------------------------------------------------------- */
  Future onCancel(String hostID, String roomID) async {
    var info = await getUserInfo();
    var result = await MainRepo.mutationGraphQL(
        await getToken(), mutation.cancelJoinRequest(hostID, roomID, info['userID']));
    return result;
  }

  void clear() {
    _rooms.clear();
    rebuildStates();
  }
}
