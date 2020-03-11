import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Message.dart';
import 'package:gamming_community/class/PrivateRoom.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/messages/models/get_list_room.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  var formatter = DateFormat('dd MMM');
  return formatter.format(dateTime);
}

String formatDateTime(DateTime dateTime) {
  var formatter = DateFormat('hh:mm');
  return formatter.format(dateTime);
}

class Messages extends StatefulWidget {
  final String userID;
  Messages({this.userID});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with AutomaticKeepAliveClientMixin<Messages>, TickerProviderStateMixin {
  GraphQLQuery query = GraphQLQuery();
  Config config = Config();
  String roomName = "Sample here";
  bool isSubmited = false;
  final chatController = TextEditingController();
  ScrollController _scrollController;
  AnimationController animationController;
  List<Message> item = [];
  List<PrivateRoom> listPrivateRoom= [];
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

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {});
      print("to bottom");
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    GetListRoom(userID: widget.userID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    super.build(context);
    return GraphQLProvider(
        client: config.client,
        child: CacheProvider(
          child: Scaffold(
            floatingActionButton:
                FloatingActionButton(
                  heroTag: "addnewMessage",
                  child: Icon(Icons.add), onPressed: () {}),
            body: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  suffixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 12.0),
                                    child: Icon(Icons
                                        .search), // myIcon is a 48px-wide widget.
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Active friends",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            //demo
                            Expanded(
                              flex: 4,
                              child: FutureBuilder(
                                future: getImage(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  } else
                                    {
                                     
                                      return ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              width: 20,
                                            ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return CachedNetworkImage(
                                            fadeInCurve: Curves.easeIn,
                                            fadeInDuration:
                                                Duration(seconds: 2),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10000),
                                                  image: DecorationImage(
                                                      image: imageProvider)),
                                            ),
                                            imageUrl: snapshot.data[index],
                                            placeholder: (context, url) =>
                                                SpinKitThreeBounce(
                                                    color: Colors.white,
                                                    size: 10),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          );
                                        });
                                    }
                                },
                              ),
                            ),
                          ],
                        ))),
                    Expanded(
                        flex: 2,
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Messages",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Query(
                                  options: QueryOptions(
                                      documentNode: gql(query
                                          .getPrivateMessage(widget.userID))),
                                  builder: (QueryResult result,
                                      {VoidCallback refetch,
                                      FetchMore fetchMore}) {
                                    if (result.hasException) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            "assets/icons/empty_icon.svg"),
                                      );
                                    }
                                    if (result.loading) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: SpinKitCubeGrid(
                                            size: 20, color: Colors.white),
                                      );
                                    }
                                    if (result.data.isNotEmpty == true) {
                                      return Align(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            "assets/icons/empty_icon.svg"),
                                      );
                                    } else
                                      {
                                        //listPrivateRoom=  PrivateRoom.fromJson(result.data);
                                        return ListView.builder(
                                        controller: _scrollController,
                                        itemBuilder: (context, index) {
                                          var animation =
                                              Tween(begin: 0.0, end: 1.0)
                                                  .animate(CurvedAnimation(
                                            parent: animationController,
                                            curve: Interval(
                                                (1 / listPrivateRoom.length) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ));
                                          return FadeTransition(
                                              opacity: animation,
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(AppConstraint.sample_proifle_url
                                                            )),
                                                title: Text(
                                                    "${listPrivateRoom[index].name}"),
                                                onTap: () {
                                                  /*Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          ConversationPage(
                                                              rooms[index]),
                                                    ),
                                                  );*/
                                                },
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "${listPrivateRoom[index].featureMessage}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          size: 8),
                                                    ),
                                                    Text(
                                                      "${formatDate(DateTime.now().toLocal())}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                        itemExtent: 100.0,
                                        itemCount: item.length,
                                      );}
                                  }),
                            )
                          ],
                        )))
                  ],
                )),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
