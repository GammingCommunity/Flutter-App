import 'package:gamming_community/view/messages/chat_message.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatProvider extends StatesRebuilder{
  String socketID;
  IO.Socket socket;
  List<ChatMessage> messages = [];

  void onAddNewMessage(ChatMessage chatMessage) {
    
    this.messages.add(chatMessage);
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

  void joinRoom(String chatID){
    socket.emit("join-chat-private",{"currentSocket": this.socketID, "roomID": chatID});
  }

  void dispose() {
    socket.disconnect();
    messages.clear();
    //socket.destroy();
    socket.clearListeners();
  }
}