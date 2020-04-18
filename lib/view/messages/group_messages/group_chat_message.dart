import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/repository/upload_image.dart';
import 'package:gamming_community/utils/display_image.dart';
import 'package:gamming_community/view/messages/group_messages/group_chat_service.dart';
import 'package:http/http.dart' as http;
import 'package:optimized_cached_image/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupChatMessage extends StatefulWidget {
  final bool fromStorage;
  final IO.Socket socket;
  final String type;
  final String currentID;
  final String roomID;
  final Map<String, dynamic> sender;
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

  //for upload image from local
  Future showProgress() async {
    print("roomID ${widget.roomID}");
    http.StreamedResponse upload = await ImageService.chatImage(widget.roomID, widget.imageUri);
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
      print(result[0]['url']);
      widget.socket.emit('chat-group', [
        GroupChatService.mediaMessage(widget.roomID, widget.currentID, result[0]['url'],
            result[0]['height'], result[0]['width'])
      ]);
    });
  }

  Future _generatePalete(BuildContext context, String imagePath, bool fromStorage) async {
    //check imagePath is uri or url

    PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
        fromStorage == true
            ? AssetImage(imagePath)
            : CachedNetworkImageProvider(widget.type == "media" ? widget.text.content : ""),
        size: Size(110, 150),
        maximumColorCount: 20);

    Navigator.of(context).push(PageTransition(
        child: DisplayImage(
            imageUrl: fromStorage == true ? widget.imageUri : widget.text.content,
            fromStorage: fromStorage,
            palate: paletteGenerator),
        type: PageTransitionType.scale,
        curve: Curves.fastLinearToSlowEaseIn,
        alignment: Alignment.center,
        duration: Duration(milliseconds: 500)));
  }

  @override
  void initState() {
    super.initState();
    widget.fromStorage ?? showProgress();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween(begin: 0, end: 1).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isMe = widget.currentID == widget.sender['id'];
    bool fromStorage = widget.fromStorage;
    var imageUri = widget.imageUri;
    var imageUrl = widget.text.content;
    return SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: widget.animationController, curve: Curves.easeOut), //new
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
                    backgroundImage: NetworkImage(widget.sender['profile_url']),
                  ),
                ),
              if (isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/300"),
                ),
              if (widget.type == "text")
                Flexible(
                  child: Container(
                      //alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                      ),
                      child:
                          Text(widget.text.content, style: Theme.of(context).textTheme.bodyText2)),
                ),
              if (widget.type == "media")
                Flexible(
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: () {
                      _generatePalete(context, imageUrl, fromStorage);
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
                                  child: OptimizedCacheImage(
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
                )
            ],
          ),
        ) //new
        );
  }

  @override
  bool get wantKeepAlive => true;
}
