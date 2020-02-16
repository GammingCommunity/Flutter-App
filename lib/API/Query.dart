class GraphQLQuery {
   String login(String username,String password){
    return """
      query{
          login(username:"$username" pwd:"$password"){
                status
                token
                account{
                  id
                  name
                }
              }
        }
    """;
  }
  String getAllRoom()=> """
    query(\$page:Int!,\$limit:Int!){
       getAllRoom(page:\$page,limit:\$limit){
          _id
          hostID
          roomName
          isPrivate
          game{
            gameID
            gameName
          }
          maxOfMember
          member
          description
          createAt
      }
    }
  """;
  String getRoomByUser(String userName) {
    return """
        {
          getRoomByUser(name:"$userName"){
            _id
            room_name
            host_name{
              username
              avatar
              isHost
            }
            isPrivate
            password
            member{
              username
              avatar
            }
          }
        }
      """;
  }

  String getRoomByID(String id) {
    return """
     query{
  getRoomByID(idRoom:"$id") {
     _id
    member{
      username
      avatar
    }
    room_name
    host_name{
      username
      avatar
    }
    isPrivate
    password
    description
  }
}
    """;
  }

  String updateRoom(String idRoom, String roomName, bool isPrivate, String pwd,
      String descrp) {
    return """
    query{
      EditRoom(idRoom:"$idRoom",newData:{
          room_name:"$roomName"
          isPrivate:$isPrivate
          password:"$pwd"
          description:"$descrp"
        }){
          result
        }
    }
     
    """;
  }

  String getRoomJoin(String userID) {
    return """
      query{
        getRoomJoin(UserID:"$userID"){
            _id
            room_name
            host_name{
              _id
              avatar
              username
              isHost
            }
            member{
              _id
              username
              avatar
              isHost
            }
        }

      }
    """;
  }

  String getAllMessage(String idRoom) {
    return """
      query{
        getAllMessage(id_room:"$idRoom"){
          messages{
            IDUser
            text
            datetime
          }
        }
      }
    """;
  }

  String findRoomByName(String roomName) {
    return """
      query{
          findRoomByName(room_name:"$roomName"){
            _id
            member{
              username
              avatar
            }
            room_name
            host_name{
              username
              avatar
            }
            isPrivate
            password
            description
             }
        }
    """;
  }

  String getListGame(int limit) {
    return """
        query{
      LG:getListGame(limit:$limit){
        _id
        game_name
        logo
        image
      }
    }
    """;
  }

  String getGameByGenres(String genre) => """
    query{
      getGameByGenre(type:"$genre"){
          _id
          game_name
          genres
          platforms
          cover_image
        }
    }
  """;
  String getAccountInfo(String accessToken, String codeToken) {
    return """
      query{
      getAccount(auth:{
        access_token:"$accessToken"
        code_token:"$codeToken"
      }){
        account_name
        id_account
      }
    }
    """;
  }
}
