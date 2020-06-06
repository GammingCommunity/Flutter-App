import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../private_message/private_message.dart';

class PrivateChatProvider extends StatesRebuilder{
  IO.Socket socket;
  String socketID = "";
  List<PrivateMessage> messages = [];

  void onAddNewMessage(PrivateMessage chatMessage) {
    this.messages.add(chatMessage);
    rebuildStates();
  }

  


  void initSocket() async{
    var token = await getToken();
    socket = IO.io('https://socket-chat-io.glitch.me/', <String, dynamic>{
      'transports': ["websocket"],
      'extraHeaders': {"token": token},
      "autoConnect": false
    });
    socket.connect();

    socket.emit("request-socket-id");

    socket.on("get-socket-id", (data) => {this.socketID = data});

    socket.on('connection', (_) {
      print('connect');
    });
    
    socket.on('disconnect', (_) => print('disconnect'));
    
  }
  
  void joinRoom(String chatID){
    socket.emit("join-chat-private",{"currentSocket": this.socketID, "roomID": chatID});
  }
  
  void dispose() {
    socket.disconnect();
    messages.clear();
    socket.destroy();
    socket.clearListeners();
  }
}