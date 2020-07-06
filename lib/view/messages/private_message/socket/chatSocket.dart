import 'package:flutter/animation.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/messages/private_message/model/private_message.dart';
import 'package:gamming_community/view/messages/private_message/private_chat_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket {
  IO.Socket socket;
  String _socketID = "";

  Future initSocket(String chatID) async {
    var token = await getToken();
    socket = IO.io('https://socketchat.glitch.me/', <String, dynamic>{
      'transports': ["websocket"],
      'extraHeaders': {"token": token},
      "autoConnect": false
    });
    socket.connect();

    socket.emit("request-socket-id");

    socket.on("get-socket-id", (data) => {this._socketID = data});

    socket.emit("join-chat-private", [chatID]);

    socket.on('connection', (_) {
      print('connect');
    });

    socket.on('disconnect', (_) => print('disconnect'));
  }

  void sendTextToSocket(String conservationID, String sender, String receiver, String content) {
    socket.emit('chat-private', [
      [
        {'chatID': conservationID},
        {
          "sender": sender,
          "receiver": receiver,
          "messageType": "text",
          "text": {
            "content": content,
          },
        }
      ]
    ]);
  }

  void sendMediaToSocket() {}

  Future onReceiveMessage() async {
    socket.on('receive-message-private', (data) async {
      print('recive message' + data.toString());
      // await displayNotification(data[0].id, data[1].text.content);

      await Future.delayed(Duration(milliseconds: 100));

      //animateToBottom();
    });
  }

  void dispose() {
    socket.disconnect();

    socket.destroy();
    socket.clearListeners();
  }
}
