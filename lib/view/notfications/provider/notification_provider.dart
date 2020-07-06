import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import '../model/friend_request_model.dart';
import '../model/global_notification_model.dart';
import '../model/pending_model.dart';

class NotificationProvider {
  var _query = GraphQLQuery();

  var globalNotification = <GlobalNotificaition>[];
  var pending = <PendingRequest>[];
  var friendsRequest = <FriendRequest>[];

  Future loadFriendRequest() async {
    var result = await SubRepo.queryGraphQL(await getToken(), _query.getFriendRequest());
    var request = FriendsRequest.fromJson(result.data['getFriendRequests']).friendsRequest;
    friendsRequest.addAll(request);
  }

  Future loadPendingRequest() async {
    var info = await getUserInfo();
    var result =
        await MainRepo.queryGraphQL(await getToken(), _query.getPendingJoinRoom(info['userID']));

    var pendings = PendingRequests.fromJson(result.data['getPendingJoinRoom_User']).listPending;
    pending.addAll(pendings);
  }


}
