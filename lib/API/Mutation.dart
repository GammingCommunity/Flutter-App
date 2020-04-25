class GraphQLMutation {
  String addRoom(String hostID, String roomName, bool isPrivate, int numofMember, String gameID,
          String gameName) =>
      """
        mutation{
            createRoom(userID:"$hostID",roomInput:{
            roomName:"$roomName"
            isPrivate:$isPrivate,
            hostID:"$hostID"
            member:["$hostID"]
            maxOfMember:$numofMember
            game:{
              gameID:"$gameID"
              gameName:"$gameName"
            }
          },roomChatInput:{
              roomID:""
              member:["$hostID"]
              messages:[]
          }){
            status
            success
            message
            payload
          }
      }
  """;

  String removeRoom(String roomID, String userID) => """
    mutation{
      removeRoom(roomID:"$roomID",userID:"$userID"){
          status
          success
          message
        }
      }
    """;
  /* need variables: current,roomID */
  String joinRoom() => """
    mutation(\$current:String!,\$roomID:String!){
      joinRoom(roomID:\$roomID,currentUserID:\$current,info:{
        userID:\$current
        roomID:\$roomID
      }){
        message
        status
        success
      }
}
  """;
  String register(String loginName, String password, String userName) {
    return """
          mutation{
            register(account:{
            login_name:"$loginName"
            name:"$userName"
            password:"$password"
          }){
            status
            token
             account{
                name
              }
          }
          }
    """;
  }

  String editRoom(String roomID, String hostID, String roomName, bool isPrivate, String descrp,
      int numofMember, String member, String gameID, String gameName,String roomLogo,String roomBg) {
    return """
      mutation{
        editRoom(roomID:"$roomID",hostID:"$hostID",newData:{
          roomName:"$roomName"
          hostID:"$hostID"
          isPrivate:$isPrivate
          member:$member,
          description:"$descrp"
          maxOfMember:$numofMember
          game:{
            gameID:"$gameID"
            gameName:"$gameName"
          }
          roomBackground:"$roomBg"
          roomLogo:"$roomLogo"
        }){
          status
          success
          message
        }
      }
      
      """;
  }

  String changeAccountAvatar(String path) {
    return """
      mutation{
        
      }
    """;
  }

  String editAccount(
          String name, String des, String phone, String month, String year, String avatarUrl) =>
      """
    mutation{
      editThisAccount(account:{
        name:"$name"
        describe:"$des"
        phone:{phone:"$phone"}
        birth_month:{ month:"$month"}
        birth_year:{year:"$year"}
        avatar_url:"$avatarUrl"
      }){
        status
        describe
      }
    }
  """;
  String editEmail(String email) => """
    mutation {
    editAccount(account: {email: {email: "$email"}}) {
      status
      describe
    }
  }

  """;

  /// {
  ///   respond : true => has send ;
  ///   false => already sent or something else
  /// }
  String sendFriendRequest(int requestID) => """
    mutation{
      sendFriendRequest(receiver_id:$requestID)
    }
  """;
  String confirmRequest(int senderID, bool isAccept) => """
    mutation{
      confirmFriendRequest(sender_id:$senderID,is_confirm:$isAccept)
    }

  """;
}
