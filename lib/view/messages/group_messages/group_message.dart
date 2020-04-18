import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/class/ReceiveNotfication.dart';
import 'package:gamming_community/models/group_chat_provider.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/repository/upload_image.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/checkHasConnection.dart';
import 'package:gamming_community/view/messages/group_messages/SharedPref.dart';
import 'package:gamming_community/view/messages/group_messages/group_chat_message.dart';
import 'package:gamming_community/view/messages/group_messages/group_chat_service.dart';
import 'package:gamming_community/view/messages/messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:http/http.dart' as http;

class GroupMessageWidget extends StatefulWidget {
  final String roomID, currentID;
  final double silverBarHeight;
  final List member;
  GroupMessageWidget({this.roomID, this.currentID, this.member, this.silverBarHeight});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<GroupMessageWidget>
    with AutomaticKeepAliveClientMixin<GroupMessageWidget>, TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSubmited = false;
  bool showAttach = true;
  bool isTap = false;
  bool setShrinkWrap = false;
  TextEditingController chatController;
  GroupChatProvider groupchatProvider;
  ScrollController scrollController;
  GraphQLQuery query = GraphQLQuery();
  AnimationController animationController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  final RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(0, 0, 0, 0),
    end: RelativeRect.fromLTRB(0, 0, 0, 40),
  );

  OverlayEntry _mediaOverlayEntry;
  final LayerLink _layerLink = LayerLink();
  SharedPref ref = SharedPref();
  List<int> _bytes = [];
  int _total = 0, _received = 0;

  List<String> sampleUser = [
    "https://api.adorable.io/avatars/90/abott@adorable.io.png",
    "https://api.adorable.io/avatars/90/magic.png",
    "https://api.adorable.io/avatars/90/closer.png",
    "https://api.adorable.io/avatars/90/mygf.png",
    "https://api.adorable.io/avatars/90/yolo.pngCopy.png",
    "https://api.adorable.io/avatars/90/facebook.png",
    "https://api.adorable.io/avatars/90/dump.png",
    "https://api.adorable.io/avatars/90/pikachu.png",
    "https://api.adorable.io/avatars/90/lumber.png",
    "https://api.adorable.io/avatars/90/wing.png"
  ];
  Future getImage() async {
    return sampleUser;
  }

  void loadMessage() async {
    var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // TODO current profile current null for maintain reason
    //TODO add emoji
    // TODO add add picture, video , etc

    // check if cache has already cache

    switch (await checkConnection()) {
      case true:
        var result = await MainRepo.queryGraphQL("", query.getRoomMessage(widget.roomID));

        var listMessage = GroupMessages.mapFromJson(result.data).groupMessages;

        listMessage.forEach((e) {
          groupchatProvider.onAddNewMessage(GroupChatMessage(
              fromStorage: false,
              imageUri: "",
              roomID: widget.roomID,
              type: e.type,
              currentID: widget.currentID,
              sender: {"id": e.sender, "profile_url": ""},
              animationController: animationController,
              text: e.text,
              sendDate: e.createAt));
          // update to save to cache
          groupchatProvider.onAddNewMessage2(e);

          animationController.forward();
          Timer(Duration(seconds: 2), () {
            animateToBottom();
          });
        });
        break;
      default:
        List<GroupMessage> listMessage = await ref.readfromCache();
        print(listMessage.length);
        listMessage.forEach((e) {
          groupchatProvider.onAddNewMessage(GroupChatMessage(
              fromStorage: false,
              imageUri: "",
              roomID: widget.roomID,
              type: e.type,
              currentID: widget.currentID,
              sender: {"id": e.sender, "profile_url": ""},
              animationController: animationController,
              text: e.text,
              sendDate: e.createAt));
          // update to save to cache
          groupchatProvider.onAddNewMessage2(e);

          animationController.forward();
          Timer(Duration(seconds: 2), () {
            animateToBottom();
          });
        });
    }
    /*if( await ref.checkDataExist() == true){
      List<GroupMessage> listMessage=  await ref.readfromCache();
       print(listMessage.length);
      listMessage.forEach((e) {
       
      groupchatProvider.onAddNewMessage(GroupChatMessage(
          fromStorage: false,
          imageUri: "",
          roomID: widget.roomID,
          type: e.type,
          currentID: widget.currentID,
          sender: {"id": e.sender, "profile_url": ""},
          animationController: animationController,
          text: e.text,
          sendDate: e.createAt));
      // update to save to cache
      groupchatProvider.onAddNewMessage2(e);

      animationController.forward();
      animateToBottom();
    });
    }
    else{
      var result = await MainRepo.queryGraphQL("", query.getRoomMessage(widget.roomID));

      var listMessage = GroupMessages.mapFromJson(result.data).groupMessages;

        listMessage.forEach((e) {
          groupchatProvider.onAddNewMessage(GroupChatMessage(
              fromStorage: false,
              imageUri: "",
              roomID: widget.roomID,
              type: e.type,
              currentID: widget.currentID,
              sender: {"id": e.sender, "profile_url": ""},
              animationController: animationController,
              text: e.text,
              sendDate: e.createAt));
          // update to save to cache
          groupchatProvider.onAddNewMessage2(e);

          animationController.forward();
          animateToBottom();
        });
    }*/
  }

  void onSendMesasge(String message, String type) {
    //print(widget.profileUrl);
    if (chatController.text.isEmpty) return;

    var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    var groupMessage = GroupChatMessage(
      fromStorage: false,
      imageUri: "",
      currentID: widget.currentID,
      sender: {"id": widget.currentID, "profile_url": ""},
      animationController: animationController,
      type: "text",
      text: GMessage(content: message),
      sendDate: DateTime.now(),
    );

    sendMessageToSocket(type, "");

    groupMessage.animationController.forward();

    // add mess to listview
    groupchatProvider.onAddNewMessage(groupMessage);

    groupchatProvider.onAddNewMessage2(GroupMessage(
        type: "text",
        createAt: DateTime.now(),
        messageID: "",
        sender: widget.currentID,
        text: GMessage(content: chatController.text, height: 0, width: 0)));

    chatController.clear();
    animateToBottom();
  }

  void onSendMessageMedia(String path, String type, bool fromLocal) async {
    var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    var groupMessage = GroupChatMessage(
      socket: groupchatProvider.socket,
      fromStorage: fromLocal,
      roomID: widget.roomID,
      currentID: widget.currentID,
      sender: {"id": widget.currentID, "profile_url": ""},
      animationController: animationController,
      imageUri: path,
      type: "media",
      sendDate: DateTime.now(),
    );

    //sendMessageToSocket(type);

    groupMessage.animationController.forward();

    // add mess to listview
    groupchatProvider.onAddNewMessage(groupMessage);

    chatController.clear();
    animateToBottom();
  }

  void sendMessageToSocket(String type, String imageUrl) {
    groupchatProvider.socket.emit('chat-group',
        [GroupChatService.textMessage(widget.roomID, widget.currentID, chatController.text)]);
    animateToBottom();
  }

  void onRecieveMessage() {
    groupchatProvider.socket.on('group-message', (data) async {
      print('recive message' + data.toString());

      notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

      var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

      var initializationSettings = InitializationSettings(initializationSettingsAndroid, null);

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'your channel id', 'your channel name', 'your channel description',
          importance: Importance.Max, priority: Priority.High, ticker: 'ticker');

      var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);
      await flutterLocalNotificationsPlugin
          .show(0, data[1]['id'], data[1]['text'], platformChannelSpecifics, payload: 'item x');

      var animationController =
          AnimationController(vsync: this, duration: Duration(milliseconds: 500));

      var chatMessage = GroupChatMessage(
          sender: {"id": data[1]['id'], "profile_url": ""},
          text: data[1]['text'],
          animationController: animationController,
          sendDate: DateTime.now());
      //add message to end
      chatMessage.animationController.forward();
      // add message to list and update UI
      groupchatProvider.onAddNewMessage(chatMessage);

      await Future.delayed(Duration(milliseconds: 100));

      animateToBottom();
    });
  }

  void animateToBottom() async {
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(milliseconds: 200),
    );
  }

  void chatImage(String roomID, String path) async {
    onSendMessageMedia(path, "media", true);

    if (_mediaOverlayEntry != null) {
      _mediaOverlayEntry.remove();
      _mediaOverlayEntry = null;
    } else
      return;
    // get url and push image to other client
  }

  //display choose image and video on chat bar
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        /*left: offset.dx,
        top: offset.dy + (size.height - offset.dy - 40),*/
        width: 60,
        height: 100,
        child: CompositedTransformFollower(
          link: this._layerLink,
          showWhenUnlinked: false,
          offset: Offset(offset.dx - 10, -offset.dy - 40),
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 2.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    try {
                      if (image.path == null)
                        return;
                      else
                        chatImage(widget.roomID, image.path);

                      print('Image');
                    } catch (e) {
                      return;
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () async {
                    var image = await ImagePicker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    print('Video');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()
      ..addListener(() {
        print(MediaQuery.of(context).viewInsets.bottom);
      });
    chatController = TextEditingController();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    WidgetsBinding.instance.addPostFrameCallback((d) {
      groupchatProvider.initSocket();
      groupchatProvider.joinGroup(widget.roomID);

      loadMessage();
      onRecieveMessage();
      animateToBottom();
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    groupchatProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var silverBarHeight = widget.silverBarHeight;
    groupchatProvider = Injector.get(context: context);

    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      // pass chat id here
      // endDrawer: ListUserDrawer(chatID: widget.chatID),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // tap to close keyboard
          FocusScope.of(context).requestFocus(new FocusNode());
          // hide choose image/video if click outside
          if (this._mediaOverlayEntry != null) {
            this._mediaOverlayEntry.remove();
            isTap = false;
          } else {
            return;
          }
        },
        child: Container(
          height: screenSize.height - 50,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // message area
              buildGroupChat(),
              SizedBox(height: 10),
              buildTextComposer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGroupChat() {
    return Expanded(
        child: ListView.builder(
            addAutomaticKeepAlives: true,
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
            itemCount: groupchatProvider.messages.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  if (index == 0) Text(formatDate(groupchatProvider.messages[index].sendDate)),
                  SizedBox(height: 5),
                  if (index != 0 &&
                      groupchatProvider.messages[index - 1].sendDate.minute !=
                          groupchatProvider.messages[index].sendDate.minute)
                    SizedBox(height: 5),
                  Text(formatDateTime(groupchatProvider.messages[index].sendDate)),
                  SizedBox(height: 5),
                  groupchatProvider.messages[index],
                ],
              );
            }));
  }

  Widget buildTextComposer() {
    return Container(
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        color: Color(AppConstraint.searchBackground),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            left: 40,
            child: TextField(
                scrollPadding: EdgeInsets.all(0),
                onTap: () {
                  setState(() {
                    setShrinkWrap = true;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    isSubmited = true;
                  });
                },
                controller: chatController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Text here',
                )),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topRight,
              child: Material(
                  type: MaterialType.circle,
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  child: IconButton(
                      icon: Icon(Icons.bubble_chart),
                      onPressed: () {
                        print(
                            "${scrollController.position.viewportDimension}, ${MediaQuery.of(context).viewInsets.bottom}");
                        onSendMesasge(chatController.text, "text");
                      })),
            ),
          ),
          Positioned(
              child: CompositedTransformTarget(
            link: this._layerLink,
            child: IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: () {
                print(isTap);
                setState(() {
                  /*if (_mediaOverlayEntry == null) {
                                _mediaOverlayEntry = _createOverlayEntry();
                                isTap = false;
                                print(isTap);
                              }*/
                  if (isTap && _mediaOverlayEntry != null) {
                    _mediaOverlayEntry.remove();
                  } else {
                    this._mediaOverlayEntry = this._createOverlayEntry();
                    Overlay.of(context).insert(_mediaOverlayEntry);
                  }
                  isTap = !isTap;
                });
              },
            ),
          )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future callGroup(BuildContext context, Future getImage) {
  return showModalBottomSheet(
      context: context,
      builder: (bottomSheetBuilder) => Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: AppColors.BACKGROUND_COLOR),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Invite to call',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text('Select user')
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  )
                ],
              ),
              Expanded(
                  flex: 1,
                  child: FutureBuilder(
                      future: getImage,
                      initialData: [],
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else
                          return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    thickness: 1,
                                  ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(10000.0),
                                            child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              imageUrl: snapshot.data[index],
                                              fadeInDuration: Duration(seconds: 3),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Hummmmmmmmm",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          children: <Widget>[
                                            Positioned(
                                                child: SizedBox(
                                              width: 60,
                                              child: RaisedButton(
                                                  color: Colors.indigo,
                                                  onPressed: () {},
                                                  child: Text("Add")),
                                            ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                      }))
            ],
          )));
}
