class GraphQLMutation {
  String addRoom(String hostName, String roomName, bool isPrivate,
      String password, String description) {
    return """
    mutation {
      createRoom(username:"$hostName",inputRoom:{
        id_room:""
        member:[]
        messages:[]},
        input:{
            room_name:"$roomName"
            isPrivate:$isPrivate
            member:[]
            host_name:[]
            description:"$description"
            password:"$password"
    }){
      id_room
    	result
    }
    }
  """;
  }

  String removeRoom(String idRoom) {
    return """
    mutation{
      RemoveRoom(id:"$idRoom"){ 
        statusCode 
        result
        }
      } 
    """;
  }

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

  String changeAccountAvatar(String path) {
    return """
      mutation{
        
      }
    """;
  }
}
