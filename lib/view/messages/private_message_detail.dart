import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/PrivateMessage.dart';
import 'package:gamming_community/models/chat_provider.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/messages/chat_message.dart';
import 'package:gamming_community/view/messages/messages.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PrivateMessagesDetail extends StatefulWidget {
  final String currentID,profileUrl;
  PrivateMessagesDetail({this.currentID,this.profileUrl});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<PrivateMessagesDetail>
    with
        AutomaticKeepAliveClientMixin<PrivateMessagesDetail>,
        TickerProviderStateMixin {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String roomName = "Sample here";
  bool isSubmited = false;
  TextEditingController chatController;
  ChatProvider chatProvider;
  ScrollController scrollController;
  Config config = Config();

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
    GraphQLQuery query = GraphQLQuery();
    GraphQLClient client = config.clientToQueryMongo();
    var queryOptions = QueryOptions(
        documentNode: gql(query.getPrivateMessges(widget.currentID)));
    var result = await client.query(queryOptions);
    var listMessage = PrivateMessages.fromJson(
            result.data['getPrivateChat'], animationController)
        .privateMessages;
    print(listMessage);
    chatProvider.onAddListMessage(listMessage);
  }

  void onSendMesasge(String message) {
    print(widget.profileUrl);
    if (chatController.text.isEmpty) return;
    var animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    var chatMessage = ChatMessage(
      sender: {
        "id":widget.currentID,
        "profile_url":widget.profileUrl
      },
      animationController: animationController,
      text: chatController.text,
      sendDate: DateTime.now(),
    );
    sendMessageToSocket();

    chatMessage.animationController.forward();
    
    chatProvider.onAddNewMessage(chatMessage);

    chatController.clear();
    animateToBottom();
  }

  void sendMessageToSocket() {
    chatProvider.socket.emit('message', [
      {
        "message": chatController.text,
      }
    ]);
  }

  void onRecieveMessage() {
    chatProvider.socket.on('message', (data) async {
      print('recive message' + data.toString());
      var animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 500));
      var chatMessage = ChatMessage(
          text: data['message'],
          animationController: animationController,
          sendDate: DateTime.now());
      //add message to end
      chatMessage.animationController.forward();
      // add message to list and update UI
      chatProvider.onAddNewMessage(chatMessage);

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

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    chatController = TextEditingController();
    loadMessage();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      chatProvider.initSocket();
      onRecieveMessage();
      animateToBottom();
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    chatProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Injector.get(context: context);
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(color: Colors.white),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$roomName',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Positioned(
                        right: 5,
                        child: Material(
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  callGroup(context, getImage());
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.group),
                                onPressed: () {},
                                color: Colors.black,
                              )
                            ],
                          ),
                        ))
                  ],
                )),
            SizedBox(height: 10),
            // message area
            Flexible(
                child: ListView.builder(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
              itemCount: chatProvider.messages.length,
              controller: scrollController,
              itemBuilder: (context, index) => Column(
                children: <Widget>[
                  if (index == 0)
                    Text(formatDate(chatProvider.messages[index].sendDate)),
                  if (index != 0 &&
                      chatProvider.messages[index - 1].sendDate.minute !=
                          chatProvider.messages[index].sendDate.minute)
                    Text(formatDateTime(chatProvider.messages[index].sendDate)),
                  chatProvider.messages[index],
                ],
              ),
            )),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white70,
              ),
              child: Row(
                children: <Widget>[
                  Material(
                    type: MaterialType.circle,
                    clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
                    child: IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: () {
                          print('Attach');
                        },
                        color: Colors.black),
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
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Text here')),
                  ),
                  Material(
                      type: MaterialType.circle,
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      child: IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.bubble_chart),
                          onPressed: () {
                            onSendMesasge(chatController.text);
                          }))
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
                                            borderRadius:
                                                BorderRadius.circular(10000.0),
                                            child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              imageUrl: snapshot.data[index],
                                              fadeInDuration:
                                                  Duration(seconds: 3),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Hummmmmmmmm",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
