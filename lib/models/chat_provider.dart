import 'package:gamming_community/view/messages/chat_message.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatProvider extends StatesRebuilder{
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

    socket.on('connect', (_) {
      print('connect');
    });
    socket.on('sent', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  void dispose() {
    socket.disconnect();
    //messages.clear();
    socket.destroy();
    socket.clearListeners();
  }
}