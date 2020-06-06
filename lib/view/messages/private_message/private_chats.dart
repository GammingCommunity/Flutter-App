import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/API/config/subAuth.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/Friend.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/messages/add_convervation.dart';
import 'package:gamming_community/view/messages/friend_profile.dart';
import 'package:gamming_community/view/messages/private_message/private_message_detail.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

String formatDate(DateTime dateTime) {
  var formatter = DateFormat('EEE,dd/MM/yyyy');
  return formatter.format(dateTime);
}

String formatDateTime(DateTime dateTime) {
  var formatter = DateFormat('EEE  hh:mm');
  return formatter.format(dateTime);
}

class Messages extends StatefulWidget {
  final String userID, token;
  Messages({this.userID, this.token});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GraphQLQuery query = GraphQLQuery();
  String roomName = "Sample here";
  bool isSubmited = false;
  final chatController = TextEditingController();
  ScrollController _scrollController;
  AnimationController animationController;
  // List<Message> item = [];
  //List<PrivateRoom> listPrivateRoom = [];

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {});
      print("to bottom");
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,

        //create new conservation with friends
        floatingActionButton: FloatingActionButton(
            heroTag: "addnewMessage",
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  maintainState: true,
                  builder: (context) => AddConservation()));
            }),
        body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                buildFriendsActive(widget.token),
                // list message
                Expanded(
                    flex: 7,
                    child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                                flex: 6,
                                child: GraphQLProvider(
                                    client: customClient(widget.token),
                                    child: CacheProvider(
                                      child: Query(
                                          options: QueryOptions(
                                              documentNode: gql(
                                                  query.getAllPrivateConservation(widget.userID))),
                                          builder: (QueryResult result,
                                              {VoidCallback refetch, FetchMore fetchMore}) {
                                            if (result.hasException) {
                                              return Align(
                                                alignment: Alignment.center,
                                                child:
                                                    SvgPicture.asset("assets/icons/empty_icon.svg"),
                                              );
                                            }
                                            if (result.loading) {
                                              return Align(
                                                alignment: Alignment.center,
                                                child: AppConstraint.loadingIndicator(context, 40),
                                              );
                                            } else {
                                              var privateConservations =
                                                  PrivateConservations.fromJson(
                                                          result.data['getAllPrivateChat'])
                                                      .conservations;

                                              return ListView.builder(
                                                itemExtent: 100.0,
                                                itemCount: privateConservations.length,
                                                controller: _scrollController,
                                                itemBuilder: (context, index) {
                                                  /* var animation = Tween(begin: 0.0, end: 1.0)
                                                      .animate(CurvedAnimation(
                                                    parent: animationController,
                                                    curve: Interval(
                                                        (1 / listPrivateRoom.length) * index, 1.0,
                                                        curve: Curves.fastOutSlowIn),
                                                  ));*/
                                                  // go to message detail + notfiy new message
                                                  return InkWell(
                                                    onTap: () {
                                                      // navigate to convservation_detail
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        maintainState: true,
                                                        fullscreenDialog: true,
                                                        builder: (context) => PrivateMessagesDetail(
                                                            chatID: privateConservations[index]
                                                                .conservationID,
                                                            member:
                                                                privateConservations[index].member),
                                                      ));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            buildProfile(
                                                              privateConservations[index].member,
                                                            ),
                                                            SizedBox(width: 10),
                                                            /* Wrap(
                                                              spacing: 10,
                                                              direction: Axis.vertical,
                                                              children: <Widget>[
                                                                // get lastest message here
                                                                Text(
                                                                  "${privateConservations[index].latestMessage}",
                                                                  style: TextStyle(fontSize: 20),
                                                                ),
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <Widget>[
                                                                    Text(
                                                                        "${privateConservations[index].latestMessage}",
                                                                        style: TextStyle(
                                                                            fontSize: 15)),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(6.0),
                                                                      child: Icon(
                                                                          Icons.fiber_manual_record,
                                                                          size: 8),
                                                                    ),
                                                                    Text(
                                                                      "${formatDate(DateTime.now().toLocal())}",
                                                                      style:
                                                                          TextStyle(fontSize: 15),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),*/
                                                          ]),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          }),
                                    )))
                          ],
                        )))
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildProfile(List id) {
  var query = GraphQLQuery();
  return FutureBuilder(
      future: (Future(() async {
        return SubRepo.queryGraphQL(await getToken(), query.getUserInfo(toListInt(id)));
      })),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonTemplate.image(70, 70,10000);
        } else {
          var url = snapshot.data.data;
          return ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: CachedNetworkImage(
              height: 70,
              width: 70,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                    color: Colors.grey[400], borderRadius: BorderRadius.circular(1000)),
              ),
              imageUrl: AppConstraint.default_profile,
            ),
          );
        }
      });
}

Widget buildFriendsActive(String token) {
  var query = GraphQLQuery();
  return Flexible(
      child: ContainerResponsive(
          height: 200.h,
          width: ScreenUtil().uiWidthPx,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // text header
              Text(
                "Active friends",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBoxResponsive(
                height: 10,
              ),
              //demo , friends example
              Flexible(
                child: GraphQLProvider(
                  client: customSubClient(token),
                  child: CacheProvider(
                    child: Container(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Query(
                          options: QueryOptions(documentNode: gql(query.getAllFriend())),
                          builder: (result, {fetchMore, refetch}) {
                            if (result.loading) {
                              // skelon
                              return ListView.separated(
                                  separatorBuilder: (context, index) => SizedBoxResponsive(
                                        width: 10,
                                      ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  itemBuilder: (context, index) => ClipRRect(
                                      borderRadius: BorderRadius.circular(10000),
                                      child: Container(height: 50, width: 50, color: Colors.grey)));
                            }
                            if (result.hasException) {
                              return Row(
                                children: <Widget>[
                                  CircleIcon(
                                    icon: Icons.refresh,
                                    iconSize: 30,
                                    onTap: () {},
                                  ),
                                  Text("Refresh")
                                ],
                              );
                            } else {
                              var listFriend =
                                  ListFriends.fromJson(result.data['getFriends']).listFriend;
                              return listFriend.isEmpty
                                  ? CircleIcon(
                                      icon: FeatherIcons.plusSquare,
                                      iconSize: 25,
                                      onTap: () {},
                                    )
                                  : ListView.separated(
                                      separatorBuilder: (context, index) => SizedBoxResponsive(
                                            width: 20,
                                          ),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: listFriend.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          borderRadius: BorderRadius.circular(1000),
                                          onTap: () {
                                            // show friends profile
                                            showFriendProfile(context, token, listFriend[index].id);
                                          },
                                          child: Stack(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(10000),
                                                child: CachedNetworkImage(
                                                  fadeInCurve: Curves.easeIn,
                                                  fadeInDuration: Duration(seconds: 1),
                                                  imageBuilder: (context, imageProvider) =>
                                                      Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(10000),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: imageProvider)),
                                                  ),
                                                  imageUrl: listFriend[index].profileUrl,
                                                  placeholder: (context, url) =>
                                                      Container(color: Colors.grey),
                                                  errorWidget: (context, url, error) =>
                                                      Icon(Icons.error),
                                                ),
                                              ),
                                              Positioned(
                                                  bottom: -4,
                                                  right: -2,
                                                  child: Icon(Icons.fiber_manual_record,
                                                      color: Colors.amber))
                                            ],
                                          ),
                                        );
                                      });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )));
}
