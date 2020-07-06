import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/hive_models/member.dart';
import 'package:gamming_community/repository/upload_image.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/utils/generatePalate.dart';
import 'package:gamming_community/view/messages/group_messages/group_chat_service.dart';
import 'package:gamming_community/view/messages/private_message/view/conservation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

var currentTime = new DateTime.now();

class GroupChatMessage extends StatefulWidget {
  final bool fromStorage;
  final IO.Socket socket;
  final String type;
  final String currentID;
  final String roomID;
  final String sender;
  final GMessage text;
  final String imageUri;
  final AnimationController animationController;
  final DateTime sendDate;
  GroupChatMessage(
      {this.type,
      this.imageUri,
      this.currentID,
      this.text,
      this.animationController,
      this.sender,
      this.sendDate,
      this.roomID,
      this.socket,
      this.fromStorage});

  @override
  _GroupChatMessageState createState() => _GroupChatMessageState();
}

class _GroupChatMessageState extends State<GroupChatMessage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _total = 0, _received = 0;
  bool uploadComplete = false;
  List<int> _bytes = [];
  int byteCount = 0;
  AnimationController controller;
  Animation animation;
  Box<Members> members = Hive.box('members');

  //for upload image from local
  Future showProgress() async {
    print("roomID ${widget.roomID}");
    http.StreamedResponse upload =
        await ImageService.chatMedia("group", widget.roomID, widget.imageUri);
    // upload complete and send to other client
    _total = upload.contentLength;

    upload.stream.listen((value) {
      setState(() {
        _bytes.addAll(value);
      });
    }).onDone(() async {
      setState(() {
        uploadComplete = true;
        controller.forward();
        Future.delayed(const Duration(milliseconds: 1000)).then((value) => controller.reverse());
      });

      var convertByte = utf8.decode(_bytes);
      var result = json.decode(convertByte);
      String messageType = result;
      //TODO: fix data group message
      widget.socket.emit('chat-group', [
        GroupChatService.mediaMessage(
            widget.roomID,
            widget.currentID,
            result[0]['url'],
            messageType == MessageEnum.image ? MessageEnum.image : MessageEnum.file,
            FileInfo(fileName: "", fileSize: "", height: 0, width: 0, publicID: ""))
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.fromStorage ?? showProgress();
    /* controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        controller.forward();
      });*/
    print("U add new mess ");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isMe = widget.currentID == widget.sender;
    bool fromStorage = widget.fromStorage;
    var imageUrl = widget.text.content;
    // get username for userlist
    
    var membersByGroupID = members.get(widget.roomID).members;
    var userProfile = membersByGroupID.singleWhere((e) => e.userID == widget.sender);
    print(userProfile);
    // var userProfile = Member(image: AppConstraint.default_profile, name: "asdsad", userID: "0000");

    return SizeTransition(
        sizeFactor: CurvedAnimation(parent: widget.animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        axis: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                InkWell(
                  onTap: () {
                    print("profile");
                  },
                  borderRadius: BorderRadius.circular(1000),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userProfile.image),
                  ),
                ),
              if (isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfile.image),
                ),
              if (widget.type == "text")
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            // member name here

                            Text(userProfile.name),
                            SizedBox(width: 10),
                            Text(formatDateTime(widget.sendDate),
                                style: TextStyle(color: Colors.grey, fontSize: 10))
                          ],
                        ),
                      ),
                      Container(
                          //alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(widget.text.content,
                              style: Theme.of(context).textTheme.bodyText2)),
                    ],
                  ),
                ),
              if (widget.type == "media")
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            // member name here
                            Text(userProfile.name),
                            SizedBox(width: 10),
                            Text(formatDateTime(widget.sendDate),
                                style: TextStyle(color: Colors.grey, fontSize: 10))
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onTap: () {
                          generatePalete(context, imageUrl, fromStorage, widget.type);
                        },
                        child: Container(
                          color: Colors.grey,
                          margin: EdgeInsets.only(left: 10),
                          height: 100,
                          width: 200,
                          child: Stack(
                            children: <Widget>[
                              fromStorage == true
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Image.file(
                                        File(widget.imageUri),
                                        height: 100,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.center,
                                      child: CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        height: widget.text.height.toDouble() > 1000
                                            ? widget.text.height.toDouble() / 2
                                            : widget.text.height.toDouble(),
                                        width: widget.text.width.toDouble() > 1000
                                            ? widget.text.width.toDouble() / 2
                                            : widget.text.width.toDouble(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.center,
                                child: uploadComplete
                                    ? FadeTransition(
                                        opacity: controller,
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.indigo,
                                          size: 40,
                                        ))
                                    : Container(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ) //new
        );
  }

  @override
  bool get wantKeepAlive => true;
}
