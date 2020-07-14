import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class GameDetailProvider {
  Game game = Game();
  var _query = GraphQLQuery();
  bool descTextShowFlag = false;
  bool isShowControll = false;
  bool hideButton = true;
  bool titleExpanded = false;
  bool displaytoAppbar = true;
  bool showControl = false;
  bool hideCreateButton = false;
  bool playButton = true;

  void showTextMore(){
    descTextShowFlag = !descTextShowFlag;
  }
  

  Future initloadGameInfo(String gameID) async {
    try {
      var result = await MainRepo.queryGraphQL(await getToken(), _query.getGameInfo(gameID));
      game = Game.fromJson(result.data['getGameInfo']);
      
    } catch (e) {}
  }
}
