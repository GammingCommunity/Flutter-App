class PendingRequest {
  String userID;
  String roomID;
  bool isApprove;
  DateTime joinTime;
  PendingRequest({this.userID, this.roomID, this.isApprove, this.joinTime});

  factory PendingRequest.fromJson(Map json) {
    return PendingRequest(
        userID: json['userID'],
        roomID: json['roomID'],
        isApprove: json['isApprove'],
        joinTime: DateTime.parse(json['joinTime']).toLocal());
  }
}

class PendingRequests {
  List<PendingRequest> listPending;
  PendingRequests({this.listPending});
  factory PendingRequests.fromJson(List data) {
    var pendings = <PendingRequest>[];
    try {
      for (var item in data) {
        pendings.add(PendingRequest(
            userID: item['requestID'],
            roomID: item['roomID'],
            isApprove: item['isApprove'],
            joinTime: DateTime.parse(item['joinTime'])));
      }
    } catch (e) {
      return PendingRequests(listPending: []);
    }
    return PendingRequests(listPending: pendings);
  }
}
