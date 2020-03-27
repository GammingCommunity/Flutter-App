import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/PrivateRoom.dart';
import 'package:gamming_community/view/messages/models/get_list_room.dart';
import 'package:gamming_community/view/messages/private_message_detail.dart';
import 'package:gamming_community/view/messages/right_side_friends.dart';
import 'package:gamming_community/view/messages/search_friends.dart';
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
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  GraphQLQuery query = GraphQLQuery();
  Config config = Config();
  String roomName = "Sample here";
  bool isSubmited = false;
  final chatController = TextEditingController();
  ScrollController _scrollController;
  AnimationController animationController;
  // List<Message> item = [];
  List<PrivateRoom> listPrivateRoom = [];
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
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
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
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    super.build(context);
    return GraphQLProvider(
        client: config.client,
        child: CacheProvider(
          child: Scaffold(
            endDrawer: RightSideFriends(),
            //create new conservation with friends
            floatingActionButton: FloatingActionButton(
                heroTag: "addnewMessage",
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      maintainState: true,
                      builder: (context) => SearchFriends()));
                }),
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
                            // text header
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Active friends",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            //demo , friends example
                            Expanded(
                              flex: 2,
                              child: FutureBuilder(
                                future: getImage(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container();
                                  } else {
                                    return ListView.separated(
                                        separatorBuilder: (context, index) => SizedBox(
                                              width: 20,
                                            ),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(10000),
                                            child: CachedNetworkImage(
                                              fadeInCurve: Curves.easeIn,
                                              fadeInDuration: Duration(seconds: 2),
                                              imageBuilder: (context, imageProvider) => Container(
                                                height: 70,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(10000),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover, image: imageProvider)),
                                              ),
                                              imageUrl: snapshot.data[index],
                                              placeholder: (context, url) =>
                                                  Container(color: Colors.grey),
                                              errorWidget: (context, url, error) =>
                                                  Icon(Icons.error),
                                            ),
                                          );
                                        });
                                  }
                                },
                              ),
                            ),
                          ],
                        ))),
                    // list message
                    Expanded(
                        flex: 6,
                        child: Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        "Messages",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.indigo,
                                            borderRadius: BorderRadius.circular(15)),
                                        child: Text(
                                          "10",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Query(
                                      options: QueryOptions(
                                          documentNode:
                                              gql(query.getPrivateConservation(widget.userID))),
                                      builder: (QueryResult result,
                                          {VoidCallback refetch, FetchMore fetchMore}) {
                                        if (result.hasException) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset("assets/icons/empty_icon.svg"),
                                          );
                                        }
                                        if (result.loading) {
                                          return Align(
                                            alignment: Alignment.center,
                                            child: SpinKitCubeGrid(size: 20, color: Colors.white),
                                          );
                                        } else {
                                          var privateConservations = PrivateConservations.fromJson(
                                                  result.data['getPrivateChat'])
                                              .conservations;

                                          return ListView.builder(
                                            itemExtent: 100.0,
                                            itemCount: privateConservations.length,
                                            controller: _scrollController,
                                            itemBuilder: (context, index) {
                                              var animation = Tween(begin: 0.0, end: 1.0)
                                                  .animate(CurvedAnimation(
                                                parent: animationController,
                                                curve: Interval(
                                                    (1 / listPrivateRoom.length) * index, 1.0,
                                                    curve: Curves.fastOutSlowIn),
                                              ));
                                              // go to message detail + notfiy new message
                                              return InkWell(
                                                onTap: () {
                                                  // navigate to convservation_detail
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                    maintainState: true,
                                                    fullscreenDialog: true,
                                                    builder: (context) => PrivateMessagesDetail(
                                                      chatID: privateConservations[index].id,
                                                        currentID: privateConservations[index]
                                                            .currentUser['id'],
                                                        profileUrl: privateConservations[index]
                                                            .currentUser['profileUrl']),
                                                  ));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                      
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(1000),
                                                          child: CachedNetworkImage(
                                                            height: 70,
                                                            width: 70,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) =>
                                                                Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.grey[400],
                                                                  borderRadius:
                                                                      BorderRadius.circular(1000)),
                                                            ),
                                                            imageUrl: privateConservations[index]
                                                                .friend['profileUrl'],
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Wrap(
                                                          spacing: 10,
                                                          direction: Axis.vertical,
                                                          children: <Widget>[
                                                            // get lastest message here
                                                            Text(
                                                              "${privateConservations[index].friend['id']}",
                                                              style: TextStyle(fontSize: 20),
                                                            ),
                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                Text(
                                                                    "${privateConservations[index].message[0].text}",
                                                                    style: TextStyle(fontSize: 15)),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(6.0),
                                                                  child: Icon(
                                                                      Icons.fiber_manual_record,
                                                                      size: 8),
                                                                ),
                                                                Text(
                                                                  "${formatDate(DateTime.now().toLocal())}",
                                                                  style: TextStyle(fontSize: 15),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                              );
                                            },
                                          );
                                        }
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
