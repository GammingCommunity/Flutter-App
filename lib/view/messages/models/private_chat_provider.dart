import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../private_message/private_message.dart';

class PrivateChatProvider extends StatesRebuilder {
  var query = GraphQLQuery();
  IO.Socket socket;
  String socketID = "";
  var _messagesW = <PrivateMessage>[];
  var _messages = <Message>[];
  var _conservations = <Conservation>[];

  List<PrivateMessage> get messages => _messagesW;
  List<Conservation> get getConservation => _conservations;
  List<Message> get getMessage => _messages;
  int get countConservation => _conservations.length;

  void onAddNewMessage(PrivateMessage chatMessage) {
    this._messagesW.add(chatMessage);
    rebuildStates();
  }

  void initPrivateConservation() async {
    var result = await MainRepo.queryGraphQL(await getToken(), query.getAllPrivateConservation());
    var conservations =
        PrivateConservations.fromJson(result.data['getAllPrivateChat']).conservations;

    this._conservations.addAll(conservations);
    rebuildStates();
  }

  void loadMessage(String chatID) async {
    var result = await MainRepo.queryGraphQL(await getToken(), query.getPrivateChatMessge(chatID));
    var messages = Messages.fromJson(result.data['getPrivateChatMessage']).messages;
    _messages.addAll(messages);
    rebuildStates();
  }

  void initSocket() async {
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

  void joinRoom(String chatID) {
    socket.emit("join-chat-private", {"currentSocket": this.socketID, "roomID": chatID});
  }

  void dispose() {
    socket.disconnect();

    socket.destroy();
    socket.clearListeners();
  }
}
