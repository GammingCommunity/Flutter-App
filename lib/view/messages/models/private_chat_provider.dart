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

  void onAddNewMessage(PrivateMessage chatMessage,[bool loadOldMessage = false]) {
        loadOldMessage  ?  _messagesW.insert(0, chatMessage)  :  this._messagesW.add(chatMessage);
    rebuildStates();
  }

  Future refresh() async{
    _conservations.clear();
    rebuildStates();
    await initPrivateConservation();
  }

  Future initPrivateConservation() async {
    var result = await MainRepo.queryGraphQL(await getToken(), query.getAllPrivateConservation());
    var conservations =
        PrivateConservations.fromJson(result.data['getAllPrivateChat']).conservations;

    this._conservations.addAll(conservations);
    rebuildStates();
  }

  Future loadMessage(String chatID) async {
    try {
      var result =
          await MainRepo.queryGraphQL(await getToken(), query.getPrivateChatMessge(chatID));
      var messages = Messages.fromJson(result.data['getPrivateChatMessage']).messages;
      _messages.addAll(messages);
      rebuildStates();
    } catch (e) {}
    
  }

  Future initSocket(String chatID) async {
    var token = await getToken();
    socket = IO.io('https://socketchat.glitch.me/', <String, dynamic>{
      'transports': ["websocket"],
      'extraHeaders': {"token": token},
      "autoConnect": false
    });
    socket.connect();

    socket.emit("request-socket-id");

    socket.on("get-socket-id", (data) => {this.socketID = data});

    socket.emit("join-chat-private", [chatID]);

    socket.on('connection', (_) {
      print('connect');
    });

    socket.on('disconnect', (_) => print('disconnect'));
  }

  void dispose() {
    socket.disconnect();

    socket.destroy();
    socket.clearListeners();
  }
}
