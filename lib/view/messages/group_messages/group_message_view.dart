import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupMessage.dart';
import 'package:gamming_community/class/ReceiveNotfication.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/checkHasConnection.dart';
import 'package:gamming_community/view/messages/group_messages/group_chat_service.dart';
import 'package:gamming_community/view/messages/models/group_chat_provider.dart';
import 'package:gamming_community/view/messages/private_message/private_chats.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'group_message.dart';

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
  Box<GroupMessage> groupMessage;
  AnimationController animationController;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  /* final RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(0, 0, 0, 0),
    end: RelativeRect.fromLTRB(0, 0, 0, 40),
  );*/

  OverlayEntry _mediaOverlayEntry;
  final LayerLink _layerLink = LayerLink();

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
    // TODO add emoji
    // TODO add add picture, video , etc
    // TODO disable animate to bottom when load old message

    // use cache if has no connection
    //print(groupMessage);
    switch (await checkConnection()) {
      case true:
        //cache first

        //add to local
        //groupMessage.clear();
        var grMessageData = await groupchatProvider.initLoadMessage(widget.roomID);

        grMessageData.forEach((e) {
          addNewMessage(e,false);
        });

        break;
      case false:
      
        break;
      default:
    }
    
  }

  addNewMessage(GroupMessage e,bool loadOldMessage) {
    groupchatProvider.onAddNewMessage(GroupChatMessage(
        fromStorage: false,
        imageUri: "",
        roomID: widget.roomID,
        type: e.messageType,
        currentID: widget.currentID,
        sender: e.sender,
        animationController: animationController,
        text: e.text,
        sendDate: e.createAt.toLocal()),loadOldMessage);
    // update to save to cache
    groupchatProvider.onAddNewMessage2(e);

     animationController.forward();
    loadOldMessage ? null : Timer(Duration(seconds: 2), () {
      animateToBottom();
    });
  }

  // update cache
  void onSendMesasge(String message, String type) {
    //print(widget.profileUrl);
    if (chatController.text.isEmpty) return;

    var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    var groupMessage = GroupChatMessage(
      roomID: widget.roomID,
      fromStorage: false,
      imageUri: "",
      currentID: widget.currentID,
      sender: widget.currentID,
      animationController: animationController,
      type: "text",
      text: GMessage(content: message),
      sendDate: DateTime.now(),
    );

    sendMessageToSocket(type, "");

    groupMessage.animationController.forward();

    // add mess to listview
    groupchatProvider.onAddNewMessage(groupMessage,false);
    // add mess to list model
    groupchatProvider.onAddNewMessage2(GroupMessage(
        messageType: "text",
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
      sender: widget.currentID,
      animationController: animationController,
      imageUri: path,
      type: "media",
      sendDate: DateTime.now(),
    );

    //sendMessageToSocket(type);

    groupMessage.animationController.forward();

    // add mess to listview
    groupchatProvider.onAddNewMessage(groupMessage,false);

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
      // update db with new value
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
          sender: data['id'],
          text: data[1]['text'],
          animationController: animationController,
          sendDate: DateTime.now());
      //add message to end
      chatMessage.animationController.forward();
      // add message to list and update UI
      groupchatProvider.onAddNewMessage(chatMessage,false);

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
          offset: Offset(offset.dx - 10, -offset.dy - 55),
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
        if (scrollController.offset == scrollController.position.minScrollExtent) {
          print("load more");
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            var messages =
                await groupchatProvider.fechMoreMessage(roomID: widget.roomID, limit: 10);
            for (var item in messages) {
              addNewMessage(item,true);
            }
          });
        }
      });
    chatController = TextEditingController();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    WidgetsBinding.instance.addPostFrameCallback((d) async {
      await groupchatProvider.initSocket(widget.roomID);
      
      groupchatProvider.initMember(widget.member, widget.roomID);
      loadMessage();
      onRecieveMessage();
      
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
        child: ContainerResponsive(
          height: screenSize.height,
          padding: EdgeInsetsResponsive.only(top: 10, left: 0),
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
    return groupchatProvider.groupMessage.isEmpty
        ? Container(
            width: 20, height: 20, alignment: Alignment.center, child: CircularProgressIndicator())
        : Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                addAutomaticKeepAlives: true,
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
                itemCount: groupchatProvider.messages.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      if (index == 0)
                        buildDateTimeSeparate(groupchatProvider.messages[index].sendDate),
                      SizedBox(height: 5),
                      if (index != 0 &&
                          groupchatProvider.messages[index - 1].sendDate.day !=
                              groupchatProvider.messages[index].sendDate.day)
                        buildDateTimeSeparate(groupchatProvider.messages[index].sendDate),
                      //Text(formatDateTime(groupchatProvider.messages[index].sendDate)),
                      //SizedBox(height: 10),
                      groupchatProvider.messages[index],
                    ],
                  );
                }));
  }

  Widget buildDateTimeSeparate(DateTime datetime) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 20),
            child: Divider(
              thickness: 2,
            ),
          ),
        ),
        Text(formatDate(datetime)),
        Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Divider(
                  thickness: 2,
                )))
      ],
    );
  }

  Widget buildTextComposer() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        color: Color(AppColors.SEARCH_BACKGROUND),
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
                  child: CircleIcon(
                    icon: Icons.bubble_chart,
                    iconSize: 20,
                    onTap: () {
                      onSendMesasge(chatController.text, "text");
                    },
                  ))),
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
