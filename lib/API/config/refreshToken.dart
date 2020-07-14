import 'dart:convert';

import 'package:gamming_community/class/LoginInfo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../repository/sub_repo.dart';
import '../../API/Query.dart';
import '../../API/config/env.dart';
import '../URLEndpoint.dart';

class RefreshToken {
  static String url = URLEndpoint.authService;
  static var query = GraphQLQuery();

  static Future<bool> isVaildSession() async {
    var headers = {"token": await getToken(), "secret_key": ENV.secretKey};
    var response = await http.get(url, headers: headers);
    var status = json.decode(response.body)['status'];
    if (status == "SUCCESSFUL") {
      return true;
    }
    return false;
  }

  static Future renewToken() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    var loginInfo = refs.getStringList("loginInfo");
    var request = await SubRepo.queryGraphQL("", query.login(loginInfo[0], loginInfo[1]));
    var loginResult = LoginInfo.fromJson(request.data);
    refs.setString("userToken", loginResult.token);
  }
}
