import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PrivateChatService {
  static var _query = GraphQLQuery();
  static Future<List<User>> getFriendName(List member) async {
    var userInfo = await getUserInfo();
    var friendID = member.singleWhere((e) => e != userInfo['userID']);

    try {
      var result = await SubRepo.queryGraphQL(
          await getToken(), _query.getMutliUserInfo([int.parse(friendID)]));
      var friendName = ListUser.fromJson(result.data['lookAccount']).listUser;
      return [
        User(
            id: int.parse(userInfo['userID']),
            nickname: userInfo['userName'],
            profileUrl: userInfo['profileUrl']),
        User(
            id: friendName[0].id,
            nickname: friendName[0].nickname,
            profileUrl: friendName[0].profileUrl)
      ];
    } catch (e) {
      return [];
    }
  }

  static void chatText(Socket socket, String conservationID, String receiverID,Message message) async {
    socket.emit('chat-private', [
      [
        {'chatID': conservationID},
        {
          "sender": message.sender,
          "receiver":receiverID,
          "messageType": "text",
          "text": {
              "content":message.txtMessage.content,
          },
        }
      ]
    ]);
  }

  static void chatMedia(Socket socket, String conservationID, String receiverID,Message message,FileInfo fileInfo) async {
    socket.emit('chat-private', [
      [
        {'chatID': conservationID},
        {
          "sender": message.sender,
          "receiver":receiverID,
          "messageType": message.messageType,
          "text": {
              "content":message.txtMessage.content,
              "media":fileInfo
          },
        }
      ]
    ]);
  }
}
