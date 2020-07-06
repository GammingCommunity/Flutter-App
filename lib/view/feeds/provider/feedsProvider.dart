import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/PostQuery.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Friend.dart';
import 'package:gamming_community/class/Post.dart';
import 'package:gamming_community/repository/post_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/toListInt.dart';

@immutable
class FeedsProvider {
  static var _query = GraphQLQuery();
  static var _postQuery = PostQueryGraphQL();
  static var _mutation = GraphQLMutation();

  final posts = <Post>[];
  Future fetchPost() async {
    //fetch friends
    var userInfo = await getUserInfo();
    var results = await SubRepo.queryGraphQL(await getToken(), _query.getAllFriend());

    List<Friend> friends = ListFriends.fromJson(results.data['getFriends']).listFriend;
    friends.add(Friend(
        id: int.parse(userInfo['userID']),
        name: userInfo['userName'],
        profileUrl: userInfo['profileUrl']));
    var mapped = toListString(friends);

    var datas =
        await PostRepo.queryGraphQL(await getToken(), _postQuery.fetchUserPost(json.encode(mapped)));
    var result = Posts.fromJson(datas.data['fetchPost']).posts;
    posts.addAll(result);
  }

  Future addPost(Post post) async {
    try {
      posts.add(post);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future refresh() async {}

  Future loadMore() async {}

  Future<bool> reaction(String commentTo, String reactType, String postID, String commentID) async {
    var queryResult = await PostRepo.mutationGraphQL(
        await getToken(), _mutation.reaction(commentTo, reactType, postID, commentID));
  }

  Future init() async {
    await fetchPost();
  }
}
