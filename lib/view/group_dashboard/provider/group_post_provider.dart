import 'package:gamming_community/API/PostQuery.dart';
import 'package:gamming_community/class/GroupPost_Normal.dart';
import 'package:gamming_community/class/GroupPost_Poll.dart';
import 'package:gamming_community/repository/post_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class GroupPostProvider extends StatesRebuilder {
  PostQueryGraphQL query = PostQueryGraphQL();
  bool isLike = false;

  void like(){
    isLike = true;
    rebuildStates();
  }

  void unLike() {
    isLike = false;
    rebuildStates();
  }

  var groupPost = <GroupPostNormal>[];
  var groupPoll = <GroupPostPoll>[];
  int get countGroupPost => groupPost.length + groupPoll.length;

  Future initLoadPost(String groupID) async {
    var result =
        await PostRepo.queryGraphQL(await getToken(), query.fetchGroupPost(groupID, 1, 10));
  }
}
