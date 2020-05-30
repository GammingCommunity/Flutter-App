import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class SearchFriendsProvider {
  var _listResult = <User>[];
  var _query = GraphQLQuery();

  List<User> get listUser => _listResult;

  void clearSearchResult() => _listResult.clear();

  Future searchFriend(String key) async {
    _listResult.clear();
    var result = await SubRepo.queryGraphQL(await getToken(), _query.searchFriend(key));
    var users = ListUser.fromJson(result.data['searchAccounts']).listUser;
    _listResult.addAll(users);
  }
}
