import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/subAuth.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/Friend.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/messages/add_convervation.dart';
import 'package:gamming_community/view/messages/friend_profile.dart';
import 'package:gamming_community/view/messages/models/private_chat_provider.dart';
import 'package:gamming_community/view/messages/private_message/private_chat_service.dart';
import 'package:gamming_community/view/messages/private_message/private_message_detail.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

String formatDate(DateTime dateTime) {
  var formatter = DateFormat('EEE,dd/MM/yyyy');
  return formatter.format(dateTime);
}

String formatDateMonth(DateTime dateTime) {
  var formatter = DateFormat.MMMEd();
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
  String roomName = "Sample here";
  bool isSubmited = false;
  ScrollController _scrollController;
  AnimationController animationController;
  PrivateChatProvider _privateChatProvider;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _privateChatProvider.initPrivateConservation();
    });
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
    _privateChatProvider = Injector.get(context: context);
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
                                child: _privateChatProvider.countConservation == 0
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: AppConstraint.loadingIndicator(context),
                                      )
                                    : ListView.separated(
                                        separatorBuilder: (ctx, index) => SizedBox(
                                          height: 10,
                                        ),
                                        itemCount: _privateChatProvider.countConservation,
                                        itemBuilder: (context, index) {
                                          var coservations = _privateChatProvider.getConservation;
                                          return buildConvervation(
                                              _privateChatProvider, coservations[index]);
                                        },
                                      ))
                          ],
                        )))
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildConvervation(PrivateChatProvider prcv, Conservation cv) {
  return FutureBuilder(
    future: PrivateChatService.getFriendName(cv.member),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SkeletonTemplate.chatMessage(80);
      } else {
        List<User> users = snapshot.data;
        return InkWell(
            onTap: () {
              Get.to(
                  PrivateMessagesDetail(
                    conservationID: cv.conservationID,
                    user:users[0],
                    friend: users[1],
                  ),
                  opaque: false);
            },
            child: Container(
                height: 80,
                width: Get.width,
                child: Row(
                  children: [
                    buildProfile(cv.member),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          users[1].nickname,
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            cv.latestMessage.messageType == "media"
                                ? Text("Send media",
                                    style: TextStyle(fontSize: 15, color: Colors.white60))
                                : Text("${cv.latestMessage}",
                                    style: TextStyle(fontSize: 15, color: Colors.white60)),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(Icons.fiber_manual_record, size: 8),
                                ),
                                Text(
                                  "${formatDateMonth(DateTime.now().toLocal())}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                )));
      }
    },
  );
}

Widget buildProfile(List id) {
  var query = GraphQLQuery();
  return FutureBuilder(
      future: (Future(() async {
        return SubRepo.queryGraphQL(await getToken(), query.getMutliUserInfo(toListInt(id)));
      })),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonTemplate.image(60, 60, 10000);
        } else {
          var url = snapshot.data.data;
          return ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: CachedNetworkImage(
              height: 60,
              width: 60,
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
  return Expanded(
      flex: 1,
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
