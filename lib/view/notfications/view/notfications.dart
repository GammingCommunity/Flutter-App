import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Subscription.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/view/messages/private_message/provider/conservation_provider.dart';
import 'package:gamming_community/view/notfications/notifications_service.dart';
import 'package:gamming_community/view/notfications/provider/notification_provider.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Notfications extends StatefulWidget {
  @override
  _NotficationsState createState() => _NotficationsState();
}

class _NotficationsState extends State<Notfications> with TickerProviderStateMixin {
  GqlSubscription subscription = GqlSubscription();
  TabController tabController;
  NotificationServices notificationServices;
  FRefreshController controller;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    controller = FRefreshController();
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      await notificationProvider.loadFriendRequest();
      await notificationProvider.loadPendingRequest();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    //notificationProvider = Injector.get();
    // var requests = notificationProvider.friendsRequest;
    //var pendings = notificationProvider.pending;
    //var globalNotify = notificationProvider.globalNotification;
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
                                icon: FeatherIcons.arrowLeft,
                                iconSize: 20,
                                onTap: () {
                                  Get.back();
                                },
                              ),
                              Text("Notification Center")
                            ],
                          ),
                          Theme(
                            data: ThemeData(
                              fontFamily: "GoogleSans-Regular",
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: Container(
                              color: brighten(Colors.black, 5),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: TabBar(
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorColor: Colors.transparent,
                                  indicator: BoxDecoration(
                                    color: brighten(Colors.black, 12),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  controller: tabController,
                                  tabs: [
                                    Tab(
                                      child: Stack(children: <Widget>[
                                        // Positioned(top: 10, right: 5, child: dotNotify()),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Text("Notification"))
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
                                        // Positioned(top: 10, right: -2, child: dotNotify()),
                                        Align(
                                            alignment: Alignment.center,
                                            child: Text("Friends Request"))
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    preferredSize: Size.fromHeight(100)),
                body: WhenRebuilderOr<NotificationProvider>(
                    initState: (_, notificationProvider) =>
                        notificationProvider.setState((s) => s.loadFriendRequest()),
                    observe: () => RM.get<NotificationProvider>(),
                    onError: (err) => Text("Has error"),
                    onWaiting: () => Center(child: AppConstraint.loadingIndicator(context)),
                    builder: (context, model) => Padding(
                          padding: EdgeInsetsResponsive.all(10),
                          child: Container(
                            height: Get.height,
                            width: Get.width,
                            child: TabBarView(controller: tabController, children: [
                              // Notification
                              Container(
                                child: RefreshIndicator(
                                    onRefresh: () {
                                      // return notificationProvider.refresh(3);
                                    },
                                    child: ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return Container();
                                      },
                                    )),
                              ),
                              //Pending request join room
                              //TODO: show pending room here,
                              Container(),
                              //Friends Request
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: Get.width,
                                    child: Text("2 request"),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 250,
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
                                                      valueColor: new AlwaysStoppedAnimation<Color>(
                                                          Color(0xff6c909b)),
                                                      strokeWidth: 2.0,
                                                    ),
                                                  ),
                                                  SizedBox(width: 9.0),
                                                  Text(
                                                    "Load more",
                                                    style: TextStyle(color: Color(0xff6c909b)),
                                                  ),
                                                ],
                                              ));
                                        },
                                        onRefresh: () async {
                                          print("on refresh");
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
                                              separatorBuilder: (context, index) => Divider(),
                                              itemCount: model.state.friendsRequest.length,
                                              itemBuilder: (context, index) {
                                                var requests = model.state.friendsRequest;
                                                return ContainerResponsive(
                                                  height: 100,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(children: <Widget>[
                                                        ClipRRect(
                                                            borderRadius: BorderRadius.circular(15),
                                                            child: CachedNetworkImage(
                                                              imageUrl: requests[index].avatarUrl ??
                                                                  AppConstraint.default_profile,
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
                                                                NotificationServices.acceptRequest(
                                                                    int.parse(
                                                                        requests[index].senderID),
                                                                    true);
                                                              },
                                                              child: Text("Accept")),
                                                          FlatButton(
                                                              onPressed: () {
                                                                NotificationServices.acceptRequest(
                                                                    int.parse(
                                                                        requests[index].senderID),
                                                                    false);
                                                              },
                                                              child: Text("Dismiss"))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ))),
                                  )),
                                ],
                              )
                            ]),
                          ),
                        ))));
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
