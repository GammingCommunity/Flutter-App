class Post {
  String postId;
  String title;
  String content;
  String media;
  List tag;
  String permission;
  DateTime createdTime;
  int countComment;
  int countReaction;
  Post(
      {this.postId,
      this.title,
      this.content,
      this.media,
      this.tag,
      this.permission,
      this.createdTime,
      this.countComment,
      this.countReaction});
}

class Posts {
  List<Post> posts;
  Posts({this.posts});
  factory Posts.fromJson(List json) {
    var posts = <Post>[];
    try {
      json.forEach((e) {
        posts.add(Post(
            postId: e['post_id'],
            title: e['title'],
            content: e['content'],
            media: e['media'],
            permission: e['permission'],
            tag: e['tag'],
            createdTime: DateTime.parse(e['created_time']).toLocal(),
            countComment: e['countComment'],
            countReaction: e['countReaction']));
      });
      return Posts(posts: posts);
    } catch (e) {
      print(e);
      return Posts(posts: []);
    }
  }
}
