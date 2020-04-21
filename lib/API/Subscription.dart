class GqlSubscription{
  String onJoinRoom(String hostID) =>"""
    subscription onJoinRoom{
onJoinRoom(hostID:"$hostID"){
        roomName
        userID
        joinTime
        isApprove
      }
    }
      
    
  """;
}