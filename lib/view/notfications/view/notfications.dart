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
import 'package:gamming_community/view/notfications/view/friend_request_tab.dart';
import 'package:gamming_community/view/notfications/view/pending_join_tab.dart';
import 'package:gamming_community/view/notfications/view/recent_notification_tab.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    //notificationProvider = Injector.get();
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
                          Expanded(
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 40),
                                    child: Text("Notification Center"),
                                  )))
                        ],
                      ),
                      buildTab(tabController)
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(100)),
            body: Padding(
              padding: EdgeInsetsResponsive.all(10),
              child: StateBuilder<NotificationProvider>(
                observe: () => RM.get<NotificationProvider>(),
                initState: (context, model) => model.setState((s) => s.init()),
                builder: (context, model) =>  Container(
                height: Get.height,
                width: Get.width,
                child: TabBarView(controller: tabController, children: [
                  // Notification
                  RecentNotificationTab(),
                  //Pending request join room
                  PendingJoinTab(),
                  //Friends Request
                  FriendRequestTab()
                ]),
              ),
              )
            )));
  }
}

Widget buildTab(TabController tabController) {
  return Theme(
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
                // Positioned(top: 10, right: -2, child: dotNotify()),
                Align(alignment: Alignment.center, child: Text("Friends Request"))
              ]),
            ),
          ],
        ),
      ),
    ),
  );
}
