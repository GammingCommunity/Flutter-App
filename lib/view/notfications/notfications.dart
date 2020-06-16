import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Subscription.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/repository/room_repo.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/notfications/notificationProvider.dart';
import 'package:gamming_community/view/notfications/notifications_service.dart';
import 'package:gamming_community/view/notfications/roomInfo_widget.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Notfications extends StatefulWidget {
  @override
  _NotficationsState createState() => _NotficationsState();
}

class _NotficationsState extends State<Notfications> with TickerProviderStateMixin {
  GqlSubscription subscription = GqlSubscription();
  TabController tabController;
  NotificationProvider notificationProvider;
  NotificationServices notificationServices;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notificationProvider.loadFriendRequest();
      notificationProvider.loadPendingRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    notificationProvider = Injector.get(context: context);
    var requests = notificationProvider.friendsRequest;
    var pendings = notificationProvider.pending;
    var globalNotify = notificationProvider.globalNotification;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: PreferredSize(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleIcon(
                            icon: FeatherIcons.chevronLeft,
                            iconSize: 20,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Theme(
                        data: ThemeData(
                          fontFamily: "GoogleSans-Regular",
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: Colors.transparent,
                          indicator: BoxDecoration(

                              color:Colors.indigo,
                              borderRadius: BorderRadius.circular(15),
                              ),
                          controller: tabController,
                          tabs: [
                            Tab(
                              child: Stack(children: <Widget>[
                                Positioned(top: 10, right: 5, child: dotNotify()),
                                Align(alignment: Alignment.center, child: Text("Notification"))
                              ]),
                            ),
                            Tab(
                              child: Stack(children: <Widget>[
                                //Positioned(top: 10, right: 20, child: dotNotify()),
                                Align(alignment: Alignment.center, child: Text("Pending"))
                              ]),
                            ),
                            Tab(
                              child: Stack(children: <Widget>[
                                Positioned(top: 10, right: -2, child: dotNotify()),
                                Align(alignment: Alignment.center, child: Text("Friends Request"))
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(100)),
            body: Padding(
              padding: EdgeInsetsResponsive.all(10),
              child: Container(
                height: ScreenUtil().uiHeightPx,
                width: ScreenUtil().uiWidthPx,
                child: TabBarView(controller: tabController, children: [
                  // Notification
                  Container(
                    child: RefreshIndicator(
                        onRefresh: () {
                          return notificationProvider.refresh(3);
                        },
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {},
                        )),
                  ),
                  //Pending
                  //TODO: show pending room here,
                  Container(
                    child: pendings.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () {
                              return notificationProvider.refresh(3);
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                thickness: 2,
                              ),
                              itemCount: pendings.length,
                              itemBuilder: (context, index) {
                                return ContainerResponsive(
                                  padding: EdgeInsetsResponsive.all(10),
                                  height: 80.h,
                                  child: Row(
                                    children: <Widget>[
                                      RoomInfo(
                                          future: RoomRepo.loadingRoomInfo(pendings[index].roomID),
                                          joinTime: pendings[index].joinTime),
                                      Spacer(),
                                      ContainerResponsive(
                                        height: 30.h,
                                        width: 60.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Text("Pending"),
                                      )
                                    ],
                                  ),
                                );
                              },
                            )),
                  ),
                  //Friends Request
                  notificationProvider.hasValue
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          child: notificationProvider.checkFriendsRequest
                              ? Text("No friends request now.")
                              : RefreshIndicator(
                                  onRefresh: () {
                                    return notificationProvider.refresh(3);
                                  },
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) => Divider(),
                                    itemCount: requests.length,
                                    itemBuilder: (context, index) {
                                      return ContainerResponsive(
                                        height: 100,
                                        child: Column(
                                          children: <Widget>[
                                            Row(children: <Widget>[
                                              ClipRRect(
                                                  borderRadius: BorderRadius.circular(10000),
                                                  child: CachedNetworkImage(
                                                    imageUrl: requests[index].avatarUrl,
                                                    height: 50,
                                                    width: 50,
                                                  )),
                                              SizedBoxResponsive(width: 10),
                                              Text(requests[index].name)
                                            ]),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: <Widget>[
                                                FlatButton(
                                                    onPressed: () {
                                                      notificationServices.acceptRequest(
                                                          int.parse(requests[index].senderID),
                                                          true);
                                                    },
                                                    child: Text("Accept")),
                                                FlatButton(
                                                    onPressed: () {
                                                      notificationServices.acceptRequest(
                                                          int.parse(requests[index].senderID),
                                                          false);
                                                    },
                                                    child: Text("Dismiss"))
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                        ),
                ]),
              ),
            )));
  }
}

//  GraphQLProvider(
//         client: customClient(""),
//         child: CacheProvider(
//           child: Scaffold(
//             body: Container(
//               height: screenSize.height,
//               width: screenSize.width,
//               child: Subscription(
//                 "",
//                 subscription.onJoinRoom(),
//                 builder: ({error, loading, payload}) {
//                   return Center(
//                     child: Text("Notfication"),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
/*Row(
                      children: <Widget>[
                        Text(
                          "Request",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(20)),
                        ),
                        Spacer(),
                        ContainerResponsive(
                          alignment: Alignment.center,
                          height: 30.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.indigo
                          ),
                          child: Text("15"))
                      ],
                    ),*/
Widget dotNotify() {
  return ContainerResponsive(
    height: 10.h,
    width: 10.w,
    decoration: BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
  );
}
