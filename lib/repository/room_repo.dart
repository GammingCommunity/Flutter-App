import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/get_token.dart';

class RoomRepo {
  static var _query = GraphQLQuery();



  static Future<GroupChat> loadingRoomInfo(String roomID) async{
    var result = await MainRepo.queryGraphQL(await getToken(), _query.getRoomInfo(roomID));
    var roomInfo = GroupChat.fromJson(result.data['getRoomInfo']);
    return roomInfo;
  }
}
