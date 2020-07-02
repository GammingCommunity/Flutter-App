import 'dart:async';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Conservation.dart' as csv;
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/iconWithTitle.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/view/messages/models/private_chat_provider.dart';
import 'package:gamming_community/view/messages/private_message/private_chat_service.dart';
import 'package:gamming_community/view/messages/private_message/private_chats.dart';
import 'package:gamming_community/view/messages/private_message/private_message.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PrivateMessagesDetail extends StatefulWidget {
  final String conservationID;
  final User user;
  final User friend;
  PrivateMessagesDetail({this.conservationID, this.user, this.friend});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<PrivateMessagesDetail>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String roomName = "Sample here";
  bool isSubmited = false;
  TextEditingController chatController;
  PrivateChatProvider chatProvider;
  ScrollController scrollController;
  GraphQLQuery query = GraphQLQuery();
  AnimationController animationController;
  FRefreshController fRefreshController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

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

  Future onLoadMessage() async {
    await chatProvider.loadMessage(widget.conservationID);
    chatProvider.getMessage.forEach((e) async {
      chatProvider.onAddNewMessage(PrivateMessage(
          animationController: animationController,
          user: widget.user,
          friend: widget.friend,
          sender: e.sender,
          sendDate: e.createAt,
          text: e.txtMessage,
          messageType: e.messageType));
      animationController.forward();

      animateToBottom();
    });
  }

  void onSendMesasge(String message) {
    if (chatController.text.isEmpty) return;

    var message = PrivateMessage(
        animationController: animationController,
        user: widget.user,
        friend: widget.friend,
        sender: widget.user.id.toString(),
        sendDate: DateTime.now().toLocal(),
        text: csv.TextMessage(
          content: chatController.text,
        ),
        messageType: MessageEnum.text);

    chatProvider.onAddNewMessage(message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      message.animationController.forward();
    });

    PrivateChatService.chatText(
        chatProvider.socket,
        widget.conservationID,
        widget.friend.id.toString(),
        csv.Message(
            createAt: DateTime.now().toLocal(),
            messageType: MessageEnum.text,
            sender: widget.user.id.toString(),
            status: "SEND",
            txtMessage: csv.TextMessage(content: chatController.text)));

    chatController.clear();
    animateToBottom();
  }

  Future displayNotification(String sender, String message) async {
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
        importance: Importance.Max, ticker: 'ticker');

    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);
    await flutterLocalNotificationsPlugin.show(0, sender, message, platformChannelSpecifics,
        payload: message);
  }

  void onRecieveMessage() {
    chatProvider.socket.on('receive-message-private', (data) async {
      print('recive message' + data.toString());
      await displayNotification(data[0].id, data[1].text.content);

      await Future.delayed(Duration(milliseconds: 100));

      animateToBottom();
    });
  }

  showBottomSheet() {
    return Get.bottomSheet(
        Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconWithTitle(
                    icon: FeatherIcons.image,
                    color: Color(0xff3282b8),
                    borderRadius: 20,
                    title: "Image",
                    onTap: () {},
                  ),
                  IconWithTitle(
                    icon: FeatherIcons.video,
                    color: Colors.indigo,
                    borderRadius: 20,
                    title: "Video",
                    onTap: () {},
                  ),
                  IconWithTitle(
                    icon: FeatherIcons.file,
                    color: Color(0xff543864),
                    borderRadius: 20,
                    title: "File",
                    onTap: () {},
                  )
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.horizontal(left: Radius.circular(10), right: Radius.circular(10))),
        backgroundColor: Get.isDarkMode ? AppColors.BACKGROUND_COLOR : Colors.white);
  }

  void animateToBottom() async {
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    chatController = TextEditingController();
    fRefreshController = FRefreshController();

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      await chatProvider.initSocket(widget.conservationID);
      await onLoadMessage();

      // onRecieveMessage();
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    chatProvider.dispose();
    animationController.dispose();
    fRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Injector.get();
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
          child: Row(
            children: [
              CircleIcon(
                  icon: Icons.chevron_left,
                  onTap: () {
                    Get.back();
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(widget.friend.nickname),
                ],
              ),
            ],
          ),
          preferredSize: Size.fromHeight(40)),
      body: Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Flexible(
                child: FRefresh(
                    controller: fRefreshController,
                    footerHeight: 50,
                    footerBuilder: (setter) {
                      /*fRefreshController.setOnStateChangedCallback((state) {
                        setter(() {
                          print(fRefreshController.position);
                        });
                      });*/

                      print(fRefreshController.loadState);
                      return Container(
                          height: 38,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  backgroundColor: Color(0xfff1f3f6),
                                  valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
                                  strokeWidth: 2.0,
                                ),
                              ),
                              const SizedBox(width: 9.0),
                              Text(
                                "Loading",
                                style: TextStyle(color: Color(0xff6c909b)),
                              ),
                            ],
                          ));
                    },
                    onRefresh: () {
                      print("refresh");
                    },
                    onLoad: () {
                      print("on load");
                      fRefreshController.finishLoad();
                    },
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
                        itemCount: chatProvider.messages.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              if (index == 0)
                                Text(formatDate(chatProvider.messages[index].sendDate)),
                              SizedBox(height: 10),
                              if (index != 0 &&
                                  chatProvider.messages[index - 1].sendDate.minute !=
                                      chatProvider.messages[index].sendDate.minute)
                                Text(formatDateTime(chatProvider.messages[index].sendDate)),
                              SizedBox(height: 10),
                              chatProvider.messages[index],
                            ],
                          );
                        }))),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(AppColors.SEARCH_BACKGROUND),
              ),
              child: Row(
                children: <Widget>[
                  CircleIcon(
                    icon: Icons.attach_file,
                    onTap: () {
                      showBottomSheet();
                    },
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            isSubmited = true;
                          });
                        },
                        controller: chatController,
                        decoration:
                            InputDecoration(border: InputBorder.none, hintText: 'Text here')),
                  ),
                  CircleIcon(
                    icon: Icons.bubble_chart,
                    onTap: () {
                      onSendMesasge(chatController.text);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/*Future callGroup(BuildContext context, Future getImage) {
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
}*/
