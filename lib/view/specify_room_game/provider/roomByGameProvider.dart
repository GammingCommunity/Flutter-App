import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class RoomByGameProvider {
  var _query = GraphQLQuery();
  var groupGame = <GroupChat>[];
  String gameID = "";
  String userID = "";
  String sortType = "none";

  Future initLoad(String gameID, String groupSize) async {
    this.gameID = gameID;

    var info = await getUserInfo();
    this.userID = info['userID'];

    var room = await queryRoom(gameID, 10, 1, groupSize);
    groupGame.addAll(room);
  }

  Future refresh() async {
    groupGame.clear();
    await initLoad(gameID, 'none');
  }

  Future sortBy(String type) async {
    clear();
    switch (type) {
      case "small":
        sortType = "small";
        await sortBy(type);
        break;
      case "large":
        sortType = "large";
        await sortBy(type);
        break;
      default:
        sortType = "none";
        await sortBy(type);
    }
  }

  Future loadMore() async {
    await queryRoom(gameID, 10, 1, sortType);
  }

  Future<List<GroupChat>> queryRoom(
      String gameID, int limit, int nextPage, String groupSize) async {
    try {
      var result = await MainRepo.queryGraphQL(
          await getToken(), _query.getListRoomByID(gameID, limit, nextPage, groupSize));

      return GroupChats.fromJson(result.data['getRoomByGame']).rooms;
    } catch (e) {
      return [];
    }
  }

  void clear() {
    groupGame.clear();
  }
}
