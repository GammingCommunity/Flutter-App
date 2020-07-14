import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GameChannel.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class ExploreProvider {
  static var _query = GraphQLQuery();
  final rooms = <GameChannelM>[];
  FRefreshController _fRefreshController = FRefreshController();

  int get gameChanelLength => rooms.length;
  FRefreshController get frefreshController => this._fRefreshController;
  
  Future init() async {
    var queryResult = await MainRepo.queryGraphQL(await getToken(), _query.getListGame("DESC"));
    var result = GameChannelsM.json(queryResult.data['getListGame']).channels;
    rooms.addAll(result);
  }

  Future loadMore() async {
    var query = await MainRepo.queryGraphQL(await getToken(), _query.getListGame('DESC'));
  }

  Future refresh() async {
    clear();
    await init().then((value) => _fRefreshController.finishRefresh()).catchError((err) => BotToast.showText(text: "Has error, try again"));;
  }

  void clear() {
    rooms.clear();
  }
}
