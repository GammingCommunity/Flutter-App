class GraphQLMutation {
  String addRoom(String hostID, String roomName, String roomType, int numofMember, String gameID,
          String friendIds, String roomLogo, String roomBackground,bool needApprove) =>
      """
        mutation{
            createRoom(roomInput:{
            roomName:"$roomName"
            roomType:$roomType,
            member:$friendIds
            maxOfMember:$numofMember
            game:{
              gameID:"$gameID"
            }
            roomLogo:"$roomLogo",
            roomBackground:"$roomBackground"
          },needApproved:$needApprove){
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
    mutation(\$hostID:String!,\$currentID:String!,\$roomID:String!){
      joinRoom(roomID:\$roomID,currentID:\$currentID,info:{
      hostID:\$hostID
    userID:\$currentID
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

  String changeGroupImage({String groupID,String avatar,String cover}) => """
    mutation{
      changeGroupImage(groupID:"$groupID",avatar:"$avatar",cover:"$cover"){
        status
        success
      }
    }

  """;

  String editRoom(
      String roomID,
      String hostID,
      String roomName,
      bool isPrivate,
      String descrp,
      int numofMember,
      String member,
      String gameID,
      String gameName,
      String roomLogo,
      String roomBg) {
    return """
      mutation{
        editRoom(roomID:"$roomID",hostID:"$hostID",newData:{
          roomName:"$roomName"
          hostID:"$hostID"
          
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
  String removeFriendRequest(int userID) => """
    mutation{
      removeFriendRequest(receiver_id:$userID)
    }
  """;
  String confirmRequest(int senderID, bool isAccept) => """
    mutation{
      confirmFriendRequest(sender_id:$senderID,is_confirm:$isAccept)
    }

  """;
  String confirmJoinRequest(String hostID, String userID, String roomID) => """
    mutation{
      confirmUserRequest(hostID:"$hostID",userID:"$userID",roomID:"$roomID"){
        status
        success
      }
    }
  """;
  String cancelJoinRequest(String hostID, String roomID, String userID) => """
    mutation{
      cancelRequest(hostID:"$hostID",roomID:"$roomID",userID:"$userID"){
        status
        success
      }
    }
  """;
  String reaction(String commentTo, String reactType, String postID, String commentID) => """
    mutation{
      reaction(to:"$commentID,type:"$reactType",postID:"$postID",commentID:"$commentID"){
        status
        payload
        success
        status
      }
    }
  """;
}
