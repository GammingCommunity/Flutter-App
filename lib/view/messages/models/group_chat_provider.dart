import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/hive_models/member.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/messages/group_messages/group_message.dart';
import 'package:hive/hive.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupChatProvider extends StatesRebuilder {
  String socketID;
  IO.Socket socket;
  var query = GraphQLQuery();
  int page = 2;
  //widget
  List<GroupChatMessage> messages = [];
  //model
  List<GroupMessage> groupMessage = [];
  Box<GroupMessage> groupMessageBox = Hive.box("groupMessage");
  Box<Members> memberBox = Hive.box('members');
  void onAddNewMessage(GroupChatMessage groupchatMessage, bool loadOldMessage) {
    // true -> load old message
    // false -> load new message
    loadOldMessage  == true ? messages.insert(0, groupchatMessage) : this.messages.add(groupchatMessage);
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
        await SubRepo.queryGraphQL(await getToken(), query.getMutliUserInfo(toListInt(members)));
    var result = ListUser.fromJson(getMember.data['lookAccount']).listUser;
    for (var item in result) {
      var member = <Member>[]
        ..add(Member(image: item.profileUrl, name: item.nickname, userID: item.id.toString()));
      memberBox.put(groupID, Members(groupID: groupID, members: member));
    }
  }

  Future<List<GroupMessage>> initLoadMessage(
    String roomID,
  ) async {
    var result = await MainRepo.queryGraphQL(
        await getToken(), query.getRoomMessage(roomID: roomID, limit: 10, page: 1));

    var listMessage = GroupMessages.listFromJson(result.data['getRoomMessage']).groupMessages;

    return listMessage;
  }

  Future<List<GroupMessage>> fechMoreMessage({String roomID, int limit}) async {
    
    var result = await MainRepo.queryGraphQL(
        await getToken(), query.getRoomMessage(roomID: roomID, limit: limit, page: page));
    var listMessage = GroupMessages.listFromJson(result.data['getRoomMessage']).groupMessages;
    if (listMessage.isEmpty) {
      return [];
    } else {
      this.page++;
     print(page);
      return listMessage;
    }
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
