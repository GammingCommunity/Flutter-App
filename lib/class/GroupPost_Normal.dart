class GroupPostNormal {
  final String postID;
  final String userID;
  final String title;
  final String content;
  final String media;
  final List tag;
  final int countComment;
  final int countReaction;
  final DateTime createdTime;
  final String permission;

  GroupPostNormal(
      {this.postID,
      this.userID,
      this.title,
      this.content,
      this.media,
      this.tag,
      this.countComment,
      this.countReaction,
      this.createdTime,
      this.permission});
}

class GroupPostNormals {
  final List<GroupPostNormal> groupPostNormal;

  GroupPostNormals({this.groupPostNormal});
  factory GroupPostNormals.fromJson(List posts) {
    var groupPostNormals = <GroupPostNormal>[];
    try {
      for (var post in posts) {
        groupPostNormals.add(GroupPostNormal(
          postID: post['_id'],
          userID: post['user_id'],
          title: post['title'],
          content: post['content'],
          tag: post['tag'],
          media: post['media'],
          countComment: post['countComment'],
          countReaction: post['countReaction'],
          createdTime: DateTime.parse(post['created_time']),
          permission: post['permission'],  
        ));
        
      }
    } catch (e) {
      return GroupPostNormals(groupPostNormal: []);
    }
    return GroupPostNormals(groupPostNormal: groupPostNormals);
  }
}
