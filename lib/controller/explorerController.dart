import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/CountRoom.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:get/get.dart';

class ExplorerController extends GetxController {
  var _query = GraphQLQuery();
  var fRefreshController = FRefreshController();
  var rooms = <Room>[].obs;

  int get roomLength => this.rooms.length;
  
  @override
  void onInit() {
    init();
    ever(rooms, (value) => print("change"));
    super.onInit();
  }

  Future init() async {
    var queryResult =
        await MainRepo.queryGraphQL(await getToken(), _query.countRoomOnEachGame("ASC"));
    var result = ListNumberOfRoom.json(queryResult.data['countRoomOnEachGame']).listRoom;
    rooms.addAll(result);
  }

  Future refresh() async {}

  Future loadMore() async {}
}
