import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'model/friend_request_model.dart';
import 'model/global_notification_model.dart';
import 'model/pending_model.dart';

class NotificationProvider extends StatesRebuilder {
  bool hasValue = true;
  var query = GraphQLQuery();
  var globalNotification = <GlobalNotificaition>[];
  var pending = <Pending>[];
  var friendsRequest = <FriendRequest>[];

  Future loadFriendRequest() async {
    var result = await SubRepo.queryGraphQL(await getToken(), query.getFriendRequest());
    var request = FriendsRequest.fromJson(result.data['getFriendRequests']).friendsRequest;
    if (request.isEmpty) {
      hasValue = false;
      rebuildStates();
    } else {
      friendsRequest.addAll(request);
      rebuildStates();
    }
  }

  bool get checkFriendsRequest {
    if (friendsRequest.isEmpty) return true;
    return false;
  }

  Future refresh(int type) async {
    return null;
  }
}
