import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/messages/private_message/socket/chatSocket.dart';

import '../model/private_message.dart';

class PrivateChatProvider {
  var chatSocket = ChatSocket();
  var _query = GraphQLQuery();
  var _messagesW = <PrivateMessage>[];
  var _messages = <Message>[];

  int get countMessage => this._messagesW.length;
  List<PrivateMessage> get messagesW => _messagesW;
  List<Message> get messagesM => _messages;
  
  Future connect(
      String chatID, AnimationController animationController, User user, User friend) async {
    await chatSocket.initSocket(chatID);
    await loadMessage(chatID, animationController, user, friend);
    await chatSocket.onReceiveMessage();
  }

  closeConnection() {
    chatSocket.dispose();
  }
  void sendMessage(AnimationController animationController, ScrollController scrollController,
      String conservationID, String text, User user, User friend, String type) {
    if (text.isEmpty) return;
    // add to view
    var message = PrivateMessage(
        animationController: animationController,
        user: user,
        friend: friend,
        sender: user.id.toString(),
        sendDate: DateTime.now().toLocal(),
        text: TextMessage(
          content: text,
        ),
        messageType: MessageEnum.text);
    animationController.forward();
    _messagesW.add(message);
    animateToBottom(scrollController);
    // add to socket
    type == "text"
        ? chatSocket.sendTextToSocket(
            conservationID, user.id.toString(), friend.id.toString(), text)
        : chatSocket.sendTextToSocket(
            conservationID, user.id.toString(), friend.id.toString(), text);
  }

  void onAddNewMessage(PrivateMessage chatMessage, [bool loadOldMessage = false]) {
    loadOldMessage ? _messagesW.insert(0, chatMessage) : this._messagesW.add(chatMessage);
  }

  

  Future loadMessage(
      String chatID, AnimationController animationController, User user, User friend) async {
    try {
      var result =
          await MainRepo.queryGraphQL(await getToken(), _query.getPrivateChatMessge(chatID));
      var messages = Messages.fromJson(result.data['getPrivateChatMessage']).messages;
      //_messages.addAll(messages);

      messages.forEach((e) async {
        onAddNewMessage(PrivateMessage(
            animationController: animationController,
            user: user,
            friend: friend,
            sender: e.sender,
            sendDate: e.createAt,
            text: e.txtMessage,
            messageType: e.messageType));
        animationController.forward();
      });
    } catch (e) {}
  }

  void animateToBottom(ScrollController scrollController) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(milliseconds: 200),
    );
  }
}
