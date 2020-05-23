import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/CountRoom.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

@immutable
class ExploreProvider {
  static var _query = GraphQLQuery();
  final rooms = <Room>[];

  Future init() async {
    var queryResult =
        await MainRepo.queryGraphQL(await getToken(), _query.countRoomOnEachGame("ASC"));
    var result = ListNumberOfRoom.json(queryResult.data['countRoomOnEachGame']).listRoom;
    rooms.addAll(result);
  }
}
