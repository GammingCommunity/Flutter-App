import 'package:gamming_community/view/messages/group_messages/group_chat_message.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupChatProvider extends StatesRebuilder{
  String socketID;
  IO.Socket socket;
  List<GroupChatMessage> messages = [];

  void onAddNewMessage(GroupChatMessage groupchatMessage) {
    
    this.messages.add(groupchatMessage);
    rebuildStates();
  }

  void initSocket() async {
    socket = IO.io('https://socketchat.glitch.me/', <String, dynamic>{
      'transports': ["websocket"],
      "autoConnect": false
    });
    socket.connect();
    // request socket id
    socket.emit("request-socket-id");
    // after get socketid,
    socket.on("get-socket-id", (data) => {
      this.socketID = data
    });

    // connect
    socket.on('connection', (_) {
      print('connect');
    });
    // disconnect
    socket.on('disconnect', (_) => print('disconnect'));
  }

  void joinGroup(String roomID){
    print("room id $roomID");
    socket.emit("join-group",[roomID]);
  }

  void dispose() {
    socket.disconnect();
    messages.clear();
    //socket.destroy();
    socket.clearListeners();
  }
}