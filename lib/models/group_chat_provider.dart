import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/hive_models/member.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/messages/group_messages/group_chat_message.dart';
import 'package:hive/hive.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupChatProvider extends StatesRebuilder {
  String socketID;
  IO.Socket socket;
  var query = GraphQLQuery();
  List<GroupChatMessage> messages = [];
  List<GroupMessage> groupMessage = [];
  Box<GroupMessage> groupMessageBox = Hive.box("groupMessage");
  Box<Members> memberBox = Hive.box('members');
  void onAddNewMessage(GroupChatMessage groupchatMessage) {
    this.messages.add(groupchatMessage);
    rebuildStates();
  }

  void onAddNewMessage2(GroupMessage message) {
    this.groupMessage.add(message);
    rebuildStates();
  }

  void clearAndUpdate() {
    groupMessageBox.clear();
  }

  Future initMember(List members, String groupID) async {
    memberBox.clear();
    var getMember =
        await SubRepo.queryGraphQL(await getToken(), query.getUserInfo(toListInt(members)));
    var result = ListUser.fromJson(getMember.data['lookAccount']).listUser;
    for (var item in result) {
      var member = <Member>[]
        ..add(Member(image: item.profileUrl, name: item.nickname, userID: item.id));
      memberBox.put(groupID, Members(groupID: groupID, members: member));
    }
  }

  Future<List<GroupMessage>> initLoadMessage(
    String roomID,
  ) async {
    var result = await MainRepo.queryGraphQL(await getToken(), query.getRoomMessage(roomID, 1, 10));

    var listMessage = GroupMessages.listFromJson(result.data['getRoomMessage']).groupMessages;

    return listMessage;
  }

  Future fechMoreMessage(String roomID, int limit, int page) async {
    var result =
        await MainRepo.queryGraphQL(await getToken(), query.getRoomMessage(roomID, limit, page));
    print(result.data);
  }

  void setMember() {}

  void initSocket() async {
    var token = await getToken();
    socket = IO.io('https://socket-chat-io.glitch.me/', <String, dynamic>{
      'transports': ["websocket"],
      'extraHeaders': {"token": token},
      "autoConnect": false
    });
    socket.connect();
    // request socket id
    socket.emit("request-socket-id");
    // after get socketid,
    socket.on("get-socket-id", (data) => {this.socketID = data});

    // connect
    socket.on('connection', (_) {
      print('connect');
    });
    // disconnect
    socket.on('disconnect', (_) => print('disconnect'));
  }

  void joinGroup(String roomID) {
    print("room id $roomID");
    socket.emit("join-group", [roomID]);
  }

  void dispose() {
    socket.disconnect();
    messages.clear();
    //socket.destroy();
    socket.clearListeners();
  }
}
