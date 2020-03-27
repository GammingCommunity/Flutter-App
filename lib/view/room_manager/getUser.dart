import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

getUser(List<int> ids) async {
  try {
    SharedPreferences refs = await SharedPreferences.getInstance();
    GraphQLQuery query = GraphQLQuery();
    String token = refs.getStringList("userToken")[2];
    var result = await SubRepo.queryGraphQL(token,query.getUserInfo(ids));
    var user = ListUser.fromJson(result.data['lookAccount']);
    return user.listUser;
  } catch (e) {
    print(e);
    return [];
  }
}
