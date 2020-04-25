import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class NotificationServices {
  Future<bool> acceptRequest(int senderID, bool isAccept) async {
    //var query = GraphQLQuery();
    var mutation = GraphQLMutation();
    var result = await SubRepo.mutationGraphQL(
        await getToken(), mutation.confirmRequest(senderID, isAccept));
    if (result.data['confirmFriendRequest']) {
      return true;
    }
    return false;
  }
}
