import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:get/get.dart';

class RoomByGameController extends GetxController {
  var _noResult = false.obs;
  var _query = GraphQLQuery();
  var groupGame = <GroupChat>[].obs;
  var _groupSize = "".obs;
  var fRefreshController = FRefreshController();

  static RoomByGameController get to => Get.find<RoomByGameController>();

  String gameID = "";
  String userID = "";
  int get groupLength => this.groupGame.length;
  String get groupSize => this._groupSize.value;
  bool get isEmpty => this.groupGame.isEmpty;
  bool get noResult => this._noResult.value;

  Future refresh(String type) async {
    clear();
    _noResult.value = false;
    await initLoad(gameID, type);
  }

  Future initLoad(String gameID, String groupSize) async {
    this.gameID = gameID;

    var info = await getUserInfo();
    this.userID = info['userID'];

    var room = await queryRoom(gameID, 10, 1, groupSize);
    if (room.isEmpty) {
      groupGame.clear();
      _noResult.value = true;
    }
    return groupGame.addAll(room);
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
