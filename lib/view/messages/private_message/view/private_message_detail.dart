import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Conservation.dart' as csv;
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/iconWithTitle.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/view/messages/private_message/provider/private_chat_provider.dart';
import 'package:gamming_community/view/messages/private_message/private_chat_service.dart';
import 'package:gamming_community/view/messages/private_message/view/conservation.dart';
import 'package:gamming_community/view/messages/private_message/model/private_message.dart';
import 'package:gamming_community/view/messages/util/chatBottomSheet.dart';
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

  TextEditingController chatController;
  PrivateChatProvider chatProvider;
  ScrollController scrollController;

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

  /* Future onLoadMessage() async {
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
  }*/

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
  }

  @override
  void dispose() {
    chatController.dispose();
    animationController.dispose();
    fRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = IN.get();
    super.build(context);
    return Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
            child: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                      height: 40,
                      width: 40,
                      imageUrl: widget.friend.profileUrl ?? AppConstraint.default_profile)),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.friend.nickname),
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                      ),
                      SizedBox(width: 10),
                      Text("Online")
                    ],
                  )
                ],
              ),
              Spacer(),
              CircleIcon(
                  icon: FeatherIcons.phoneCall,
                  onTap: () {
                    BotToast.showText(text: "Make a phone call");
                  }),
              CircleIcon(icon: FeatherIcons.info, onTap: () {})
            ],
            height: 50,
            onNavigateOut: () {
              Get.back();
            },
            padding: EdgeInsets.all(0),
            backIcon: FeatherIcons.arrowLeft),
        body: WhenRebuilderOr<PrivateChatProvider>(
          initState: (context, privateChatProvider) => privateChatProvider.setState((s) async =>
              await s.connect(
                  widget.conservationID, animationController, widget.user, widget.friend)),
          dispose: (context, privateChatProvider) => privateChatProvider.state.closeConnection(),
          observe: () => RM.get<PrivateChatProvider>(),
          builder: (context, model) => Container(
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
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
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
                          fRefreshController.finishRefresh();
                        },
                        onLoad: () {
                          print("on load");
                          fRefreshController.finishLoad();
                        },
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
                            itemCount: model.state.countMessage,
                            controller: scrollController,
                            itemBuilder: (context, index) {
                              var messages = model.state.messagesW;
                              return Column(
                                children: <Widget>[
                                  if (index == 0) Text(formatDate(messages[index].sendDate)),
                                  SizedBox(height: 10),
                                  if (index != 0 &&
                                      messages[index - 1].sendDate.minute !=
                                          messages[index].sendDate.minute)
                                    Text(formatDateTime(messages[index].sendDate)),
                                  SizedBox(height: 10),
                                  messages[index],
                                ],
                              );
                            }))),
                SizedBox(height: 20),
                Container(
                  color: brighten(Colors.black),
                  child: Row(
                    children: <Widget>[
                      CircleIcon(
                        icon: FeatherIcons.paperclip,
                        onTap: () {
                          ChatBottomSheet.show();
                        },
                      ),
                      Flexible(
                        child: TextField(
                            controller: chatController,
                            decoration:
                                InputDecoration(border: InputBorder.none, hintText: 'Text here')),
                      ),
                      CircleIcon(
                        icon: FeatherIcons.send,
                        onTap: () {
                          model.setState((s) => s.sendMessage(
                              animationController,
                              scrollController,
                              widget.conservationID,
                              chatController.text,
                              widget.user,
                              widget.friend,
                              "text"));

                          chatController.clear();
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
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
