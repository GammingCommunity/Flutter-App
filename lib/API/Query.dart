class GraphQLQuery {
  String login(String username, String password) {
    return """
      query{
          login(username:"$username" pwd:"$password"){
                status
                token
                account{
                  id
                  name
                  avatar_url
                }
              }
        }
    """;
  }

  /* fetch all room */
  String getAllRoom() => """
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

  /*String getRoomByID(String id) {
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
  }*/
  String getRoomCurrentUser() => """
    query{
      roomManager{
          _id
          hostID
          roomName
          roomType
          game{
            gameID
            gameName
          }
          maxOfMember
          countMember
          member
          description
          createAt
          roomBackground
          roomLogo
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

  /*String getListGame(int limit) {
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
  }*/

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
  String getCurrentUserInfo() => """
  query{
    getThisAccount {
       id
      name
      avatar_url
      email
      phone
      count_followers
      birthmonth
      birthyear
      describe
   }
  }
 """;
  String getMutliUserInfo(List<int> ids) {
    return """
    query{
      lookAccount (ids:$ids){
        account {
          id
          name
          avatar_url
        }
      }
    }
   """;
  }

  String getAllPrivateConservation([int page = 1, int limit = 10]) => """
   query{
      getAllConservation(page:$page,limit:$limit){
        _id
        member
        isHost
        latest_message{
          id
          messageType
          status
          text{
            content
            fileInfo{
              publicID
              fileName
              height
              width
            }
          }
          createAt
        }
      }
   }
 """;
  String getSummaryByGameID(String gameID) => """
    query{
      getSummaryByGameID(gameID:"$gameID"){
          summary
        }
    }
 """;

  /// pcgamer,
  String getNews(String articleHost) => """
  query(\$page:Int!,\$limit:Int!){
    fetchNews(name:"$articleHost",page:\$page,limit:\$limit){
     article_url
    article_short
    article_image
    release_date
  }
  }
 
 """;

  ///sort: ASC, DESC
  String getListGame(String sort, [int page = 1, int limit = 10]) => """
  query{
    getListGame(page:$page,limit:$limit,sort:$sort){
      _id
      name
      banner
      count
    }
  }
 """;
  String getListRoomByID(String gameId, int limit, int page,
          [String groupSize = "none", bool hideJoined = false]) =>
      """
  query{
    getRoomByGame(gameID:"$gameId",limit:$limit,page:$page,groupSize:$groupSize,,hideJoined:$hideJoined){
       _id
      roomName
      roomType
      hostID
      game{
        gameID
        gameName
      }
      createAt
      roomLogo
      roomBackground
      member
      maxOfMember 
      countMember
      isJoin
      isRequest
  }
  }
 """;
  String getPrivateChatMessge(String chatID, [int page = 1, int limit = 10]) => """
  query{
    getPrivateChatMessage(chatID:"$chatID",page:$page,limit:$limit){
      id
      messageType
      status
      text{
        content
        fileInfo{
          fileName
          fileSize
          publicID
          height
          width
        }
      }
      createAt
  }
  }
  
 """;
  String searchGame(String query, String gameID) => """
    query{
      searchGame(name:"$query",id:"$gameID"){
        _id
        name
        logo{
          imageUrl
        }
      }
    }
 """;
  String getPrivateChatInfo(String chatID) => """
    query{
      getPrivateChatInfo(roomID:"$chatID"){
        member{
          id
          profile_url
        }
      }
    }
 """;

  ///
  ///{search friend : 1, find all in list : 0
  ///}
  ///
  String getAllFriend() => """
    query{
      getFriends{
        friend{
          id
          name
          avatar_url
        }
      }
    }
  """;

  String getFriendRequest() => """
    query{
      getFriendRequests{
      sender{
        id
        name
        avatar_url
      }
      updated_at
    }
    }
  """;
  String getRoomMessage({String roomID, int page, int limit}) => """
    query{
      getRoomMessage(roomID:"$roomID",page:$page,limit:$limit){
        sender
        messageType
        text{
          content
          fileInfo{
            fileName
            fileSize
            publicID
            height
           width
          }
        }
        createAt
      }
    }
  """;
  String getRoomInfo(String roomID) => """
    query{
      getRoomInfo(roomID:"$roomID"){
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
          roomLogo
          roomBackground
      } 
    }
  """;
  String getPendingJoinRoom() => """
    query{
      manageRequestJoin_Host{
        requestID
        roomID
        isApprove
        joinTime
      }
    }
  """;

  String searchFriend(String str, String ids) => """
    query{
      searchAccounts(key:"$str",exclude_ids:$ids){
          account{
            id
            name
            avatar_url
            describe
          }
          relationship
        }
    }
  """;
  String getGameInfo(String gameID) => """
    query{
      getGameInfo(gameID:"$gameID"){
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
}
