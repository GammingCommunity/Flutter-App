import 'dart:convert';

import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/toListInt.dart';

class SearchFriendsProvider {
  var _listResult = <User>[];
  var _query = GraphQLQuery();
  bool _hasChangeText = false;
  List<User> get listUser => _listResult;
  bool get isChangTxt => _hasChangeText;
  void clearSearchResult() => _listResult.clear();

  Future searchFriend(String key, List excludeIds) async {
    _listResult.clear();
    
    var result = await SubRepo.queryGraphQL(await getToken(), _query.searchFriend(key, json.encode(excludeIds)));
    var users = ListUser.fromJson(result.data['searchAccounts']).listUser;
    _listResult.addAll(users);
  }

  void changeText(bool val) {
    this._hasChangeText = val;
  }
}
