class FriendRequest {
  String senderID;
  String name;
  String avatarUrl;
  String updatedAt;
  FriendRequest({this.name, this.avatarUrl, this.updatedAt,this.senderID});
}

class FriendsRequest {
  List<FriendRequest> friendsRequest;
  FriendsRequest({this.friendsRequest});
  factory FriendsRequest.fromJson(List json) {
    var requests = <FriendRequest>[];
    try {
      for (var item in json) {
        requests.add(FriendRequest(
          senderID: item['sender']['id'],
            name: item['sender']['name'],
            avatarUrl: item['sender']['avatar_url'],
            updatedAt: item['updated_at']));
      }
    } catch (e) {
      return FriendsRequest(friendsRequest: []);
    }
    return FriendsRequest(friendsRequest: requests);
  }
}
