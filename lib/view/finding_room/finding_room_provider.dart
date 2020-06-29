import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FindingRoomProvider extends StatesRebuilder {
  String socketID;
  IO.Socket socket;

  bool isAbsolute = false;
  int roomSize = 0;
  String gameId = "";

  Future initConnection() async {
    var token = await getToken();
    socket = IO.io('https://fast-finding-sv.glitch.me/', <String, dynamic>{
      'transports': ["websocket"],
      'extraHeaders': {"token": token},
      "autoConnect": false
    });
    socket.connect();
    // connect
    socket.on('connection', (_) {
      print('connect');
    });
    // disconnect
    socket.on('disconnect', (_) => print('disconnect'));
  }

  Future listenEvent() async {
    socket.on("FINDING_RESULT", (data) => {print("FINDING_RESULT $data")});

    socket.on("NOTIFICATION", (data) => {print("Notifi $data")});

    socket.on("IS_FINDING_ROOMS", (data) => {print("FINDING_RESULT $data")});
  }

  Future find(bool isAbsolute, int roomSize, String gameId) async {
    // request socket id
    socket.emit("FIND_ROOMS", [{
     
      "option":{
      "isAbsolute": isAbsolute, "roomSize": roomSize, "gameId": gameId
    }}]);
    // after get socketid,
  }


  Future cancelFinding() async {
    socket.emit("UNFIND_ROOMS", [
      {"accessToken": await getToken()}
    ]);
  }

  void dispose() {
    socket.disconnect();
    //socket.destroy();
    socket.clearListeners();
  }
}
