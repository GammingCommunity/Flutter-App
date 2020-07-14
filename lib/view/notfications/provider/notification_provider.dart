import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/Subscription.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/notfication_initailization.dart';
import 'package:gamming_community/view/notfications/model/join_room_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../model/friend_request_model.dart';
import '../model/global_notification_model.dart';
import '../model/pending_model.dart';

class NotificationProvider {
  var _query = GraphQLQuery();
  var _subscription = GqlSubscription();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  var globalNotification = <GlobalNotificaition>[];
  var pending = <PendingRequest>[];
  var friendsRequest = <FriendRequest>[];

  int get countfriendRequest => this.friendsRequest.length;
  int get countjoinRoomPending => this.pending.length;

  Future initNotification() async {
    GraphQLClient client = initWebSocketLink();

    client
        .subscribe(Operation(
      operationName: "joinRoomNotification",
      documentNode: gql(_subscription.joinRoomNotification()),
    ))
        .listen((data) async {
      print("join room notification ${data.data}");
      /*await flutterLocalNotificationsPlugin.show(
          1,
          "Join room",
          "sad want to join asd",
          platformSpecific("channelID", "channelName", "channelDescription"));*/
    });

    client
        .subscribe(Operation(
            operationName: "", documentNode: gql(_subscription.acceptRequestNotification())))
        .listen((data) {
      print("accept notification");
    });
    //var result = JoinRoom.fromJson(payload);
  }

  Future init() async {
    await loadFriendRequest();
    await loadPendingRequest();
  }

  Future loadFriendRequest() async {
    friendsRequest.clear();
    var result = await SubRepo.queryGraphQL(await getToken(), _query.getFriendRequest());
    try {
      var request = FriendsRequest.fromJson(result.data['getFriendRequests']).friendsRequest;
      friendsRequest.addAll(request);
    } catch (e) {}
  }

  Future loadPendingRequest() async {
    pending.clear();
    var result = await MainRepo.queryGraphQL(await getToken(), _query.getPendingJoinRoom());

    try {
      var pendings = PendingRequests.fromJson(result.data['manageRequestJoin_Host']).listPending;
      pending.addAll(pendings);
    } catch (e) {}
  }
}
