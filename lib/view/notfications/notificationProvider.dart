import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'model/friend_request_model.dart';
import 'model/global_notification_model.dart';
import 'model/pending_model.dart';

class NotificationProvider extends StatesRebuilder {
  bool hasValue = true;
  var _query = GraphQLQuery();

  var globalNotification = <GlobalNotificaition>[];
  var pending = <PendingRequest>[];
  var friendsRequest = <FriendRequest>[];

  Future loadFriendRequest() async {
    var result = await SubRepo.queryGraphQL(await getToken(), _query.getFriendRequest());
    var request = FriendsRequest.fromJson(result.data['getFriendRequests']).friendsRequest;
    if (request.isEmpty) {
      hasValue = false;
      rebuildStates();
    } else {
      friendsRequest.addAll(request);
      rebuildStates();
    }
  }

  Future loadPendingRequest() async {
    var info = await getUserInfo();
    var result =
        await MainRepo.queryGraphQL(await getToken(), _query.getPendingJoinRoom(info['userID']));

    var pendings = PendingRequests.fromJson(result.data['getPendingJoinRoom_User']).listPending;
    pending.addAll(pendings);
    rebuildStates();
  }


  bool get checkFriendsRequest {
    if (friendsRequest.isEmpty) return true;
    return false;
  }

  Future refresh(int type) async {
    return null;
  }
}
