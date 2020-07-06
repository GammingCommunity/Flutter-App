import 'package:gamming_community/API/PostQuery.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Post.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/post_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/feeds/userPost.dart';
import 'package:get/get.dart';

class FriendProfileProvider {
  var _query = GraphQLQuery();
  var _postQuery = PostQueryGraphQL();
  String userName = "";
  String profileUrl = "";
  var userPost = <Post>[];
  var userLikePost = <Post>[];

  int get postCount => this.userPost.length;
  int get postLikeCount => this.userLikePost.length;

  Future getUserInfo(int userID) async {
    try {
      var result = await SubRepo.queryGraphQL(await getToken(), _query.getMutliUserInfo([userID]));
      var profile = ListUser.fromJson(result.data['lookAccount']).listUser;
      userName = profile[0].nickname;
      profileUrl = profile[0].profileUrl ?? AppConstraint.default_profile;
    } catch (e) {}
  }

  Future getUserPost(int userID) async {
    try {
      var result = await PostRepo.queryGraphQL(
          await getToken(), _postQuery.fetchUserPost(userID.toString()));
      var posts = Posts.fromJson(result.data['fetchPost']).posts;
      userPost.addAll(posts);
    } catch (e) {}
  }
  Future getUserLikePost(int userID) async{
    
  }
}
