class PostMutateGraphQL {
  String createPost(String title,String content,String medias,List tags,String permission) => """
    mutation{
      createPost(postInfo:{
        title:"$title"
        content:"$content"
        media:$medias
        tag:[]
        permission:$permission
    }){
      status
      success
      payload
    }
    }

  """;
}
