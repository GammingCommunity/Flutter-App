import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/subAuth.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/Friend.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/home/search_view.dart';
import 'package:gamming_community/view/messages/add_convervation.dart';
import 'package:gamming_community/view/friend_profile/view/friend_profile.dart';
import 'package:gamming_community/view/messages/private_message/provider/private_chat_provider.dart';
import 'package:gamming_community/view/messages/private_message/private_chat_service.dart';
import 'package:gamming_community/view/messages/private_message/view/private_message_detail.dart';
import 'package:gamming_community/view/messages/private_message/provider/conservation_provider.dart';

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
  AnimationController animationController;
  FRefreshController controller;

  String text = "Drop-down to loading";

  @override
  void initState() {
    super.initState();
    controller = FRefreshController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
            Get.to(AddConservation(), opaque: false, transition: Transition.upToDown);
          }),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              buildFriendsActive(widget.token),
              // list message
              Expanded(
                  flex: 8,
                  child: Container(
                      alignment: Alignment.topLeft,
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
                                    color: Colors.indigo, borderRadius: BorderRadius.circular(15)),
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
                              child: WhenRebuilderOr<ConservationProvider>(
                                  initState: (_, privateChatProvider) => privateChatProvider
                                      .setState((s) => s.initPrivateConservation()),
                                  observe: () => RM.get<ConservationProvider>(),
                                  onIdle: null,
                                  onWaiting: () =>
                                      Center(child: AppConstraint.loadingIndicator(context)),
                                  builder: (context, privateChat) => Container(
                                        height: Get.height,
                                        width: Get.width,
                                        child: FRefresh(
                                            controller: controller,
                                            headerHeight: 60,
                                            headerBuilder: (setter, constraints) {
                                              //await _privateChatProvider.refresh();
                                              return Container(
                                                height: 50,
                                                alignment: Alignment.bottomCenter,
                                                child: SizedBox(
                                                  width: 15,
                                                  height: 15,
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Color(0xfff1f3f6),
                                                    valueColor: new AlwaysStoppedAnimation<Color>(
                                                        Color(0xff6c909b)),
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
                                              );
                                            },
                                            footerHeight: 50.0,
                                            footerBuilder: (setter) {
                                              /// Get refresh status, partially update the content of Footer area

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
                                                              new AlwaysStoppedAnimation<Color>(
                                                                  Color(0xff6c909b)),
                                                          strokeWidth: 2.0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 9.0),
                                                      Text(
                                                        text,
                                                        style: TextStyle(color: Color(0xff6c909b)),
                                                      ),
                                                    ],
                                                  ));
                                            },
                                            onRefresh: () async {
                                              print("on refresh");
                                              await privateChat.state
                                                  .refresh()
                                                  .then((value) => controller.finishRefresh());
                                            },
                                            onLoad: () {
                                              print("onLoad");
                                              Timer(Duration(milliseconds: 3000), () {
                                                controller.finishLoad();
                                                print(
                                                    'controller4.position = ${controller.position}, controller4.scrollMetrics = ${controller.scrollMetrics}');
                                              });
                                            },
                                            child: Container(
                                              width: Get.width,
                                              height: Get.height,
                                              child: ListView.separated(
                                                separatorBuilder: (ctx, index) => SizedBox(
                                                  height: 10,
                                                ),
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: privateChat.state.countConservation,
                                                itemBuilder: (context, index) {
                                                  var coservations =
                                                      privateChat.state.getConservation;

                                                  return buildConvervation(coservations[index]);
                                                },
                                              ),
                                            )),
                                      )))
                        ],
                      )))
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildConvervation(Conservation cv) {
  return Container(
    height: 100,
    width: Get.width,
    child: FutureBuilder(
      future: PrivateChatService.getFriendName(cv.member),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) => SkeletonTemplate.chatMessage(80, 15),
          );
        } else {
          List<User> users = snapshot.data;
          return InkWell(
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              onTap: () {
                Get.to(
                    PrivateMessagesDetail(
                      conservationID: cv.conservationID,
                      user: users[0],
                      friend: users[1],
                    ),
                    transition: Transition.fadeIn,
                    opaque: false);
              },
              child: Row(
                children: [
                  //buildProfile(cv.member),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400], borderRadius: BorderRadius.circular(15)),
                      ),
                      imageUrl: users[1].profileUrl ?? AppConstraint.default_profile,
                    ),
                  ),
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
                      cv.latestMessage.sender == null
                          ? Container(
                              height: 20,
                              width: 20,
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                isMedia(cv.latestMessage.messageType)
                                    ? Text("Send media",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Get.isDarkMode ? Colors.white60 : Colors.black54))
                                    : Text("${cv.latestMessage.txtMessage}",
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
              ));
        }
      },
    ),
  );
}

Widget buildProfile(List id) {
  var query = GraphQLQuery();
  return FutureBuilder(
      future: (Future(() async {
        return await PrivateChatService.getFriendName(id);
        //SubRepo.queryGraphQL(await getToken(), query.getMutliUserInfo(toListInt(id)));
      })),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonTemplate.image(60, 60, 10000);
        } else {
          var url = snapshot.data[1].profileUrl;
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
              imageUrl: url ?? AppConstraint.default_profile,
            ),
          );
        }
      });
}

Widget buildFriendsActive(String token) {
  var query = GraphQLQuery();
  return Container(
      height: 100,
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // text header
          Text(
            "Active friends",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          //demo , friends example
          Flexible(
            child: GraphQLProvider(
              client: customSubClient(token),
              child: CacheProvider(
                child: Container(
                  height: 50,
                  width: 50,
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
                                borderRadius: BorderRadius.circular(15),
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
                        var listFriend = ListFriends.fromJson(result.data['getFriends']).listFriend;
                        return listFriend.isEmpty
                            ? CircleIcon(
                                icon: FeatherIcons.plusSquare,
                                iconSize: 25,
                                onTap: () {
                                  Get.to(SearchView(), opaque: false);
                                },
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                      width: 20,
                                    ),
                                scrollDirection: Axis.horizontal,
                                itemCount: listFriend.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      // show friends profile
                                      Get.to(FriendProfile(userID: listFriend[index].id),
                                          transition: Transition.leftToRightWithFade,opaque: false);
                                    },
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            fadeInCurve: Curves.easeIn,
                                            fadeInDuration: Duration(seconds: 1),
                                            imageBuilder: (context, imageProvider) => Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 3
                                                  ),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover, image: imageProvider)),
                                            ),
                                            imageUrl: listFriend[index].profileUrl ??
                                                AppConstraint.default_profile,
                                            placeholder: (context, url) =>
                                                Container(color: Colors.grey),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        ),
                                        /*Positioned(
                                            bottom: -4,
                                            right: -4,
                                            child: Icon(Icons.fiber_manual_record,
                                                color: Colors.green))*/
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
        ],
      ));
}
