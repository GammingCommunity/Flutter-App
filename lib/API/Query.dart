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
  /* fetch all room */
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
  String getRoomCurrentUser(String currentUserID)=>"""
    query{
      roomManage(hostID:"$currentUserID"){
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

  String getListGame(int limit) {
    return """
      query{
        getListGame(limit:$limit){
          _id
          name
          logo{
            imageUrl
          }
          images
          video{
            trailer
          }
      }
    }
    """;
  }

  String getGameByGenres(String genre) => """
    query{
      getGameByGenre(type:"$genre"){
          _id
          name
          genres
          platforms
          images
          logo{
            imageUrl
          }
          coverImage{
            imageUrl
          }
          video{
            trailer
          }
          summary
        }
    }
  """;
 String getCurrentUserInfo() =>"""
  query{
    lookAccount {
    account {
      name
      describe
      email {
        email
      }
      phone {
        phone
      }
      birth_month {
        month
      }
      birth_year {
        year
      }
      phone {
        phone
      }
    }
  }
  }
 """;
 String getUserInfo(String id){
   return """
    query{
      lookAccount (id:$id){
        account {
          name
        }
      }
    }
   """;
 }
 String getPrivateMessage(String userID) =>"""
   query{
      getPrivateChat(ID:"$userID"){
        messages{
          text
          createAt
        }
      }
   }
 """;
 String getSummaryByGameID(String gameID)=>"""
    query{
      getSummaryByGameID(gameID:"$gameID"){
          summary
        }
    }
 """;
 String getNews()=>"""
  query(\$page:Int!,\$limit:Int!){
    fetchNews(page:\$page,limit:\$limit){
    article_url
    article_short
    article_image
    release_date
  }
  }
 
 """;
}
