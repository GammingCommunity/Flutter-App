import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomsProvider extends StatesRebuilder {
  var query = GraphQLQuery();
  bool hasNoValue = false;
  List<Room> rooms = [];

  String gameID = "";
  String userID = "";

  int nextPage = 1;
  int limit = 6;
  /*--------------------------------------------------------------------------------- */
  Future initLoad(String gameID) async {
    this.gameID = gameID;

    var info = await getUserInfo();
    this.userID = info['userID'];

    var room = await queryRoom(gameID, userID, limit, nextPage);
    if (room.isEmpty) {
      hasNoValue = true;
      rebuildStates();
    } else {
      rooms.addAll(room);
      rebuildStates();
    }
  }

/*--------------------------------------------------------------------------------- */
  Future refresh() async {
    clear();
    initLoad(gameID);
  }

/*--------------------------------------------------------------------------------- */
  Future<List<Room>> queryRoom(String gameID, String userID, int limit, int nextPage) async {
    try {
      var result = await MainRepo.queryGraphQL(
          await getToken(), query.getListRoomByID(gameID, userID, limit, nextPage));

      return Rooms.fromJson(result.data['getRoomByGame']).rooms;
    } catch (e) {
      return [];
    }
  }

/*--------------------------------------------------------------------------------- */
  Future loadMore() async {
    print("load more");
    nextPage += 1;
    var rooms = await queryRoom(gameID, userID, limit, nextPage);
    rooms.addAll(rooms);
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
    rooms.clear();
    rebuildStates();
  }
}
