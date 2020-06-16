class PostQueryGraphQL {
  String fetchGroupPost(String groupID,int page, int limit) => """
      query{
      fetchGroupPost(groupID:"$groupID",page:$page,limit:$limit){
          posts{
           _id
            user_id
            title
            content
            media
            tag
            created_time
            countComment
            countReaction
          }
        }
    }
  """;
}
