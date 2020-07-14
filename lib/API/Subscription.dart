class GqlSubscription {
  String joinRoomNotification() => """
    subscription joinRoomNotification{
          type
          roomID
          roomName
          hostID
          requestID
          message
          isApprove
        }
            
    """;
  String acceptRequestNotification() => """
    subscription acceptRequest{
        message
        time
      }
  """;
}
