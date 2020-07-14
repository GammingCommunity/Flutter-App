import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/customWidget/customFooterFRefresh.dart';
import 'package:gamming_community/customWidget/customHeaderFRefresh.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/notfications/notifications_service.dart';
import 'package:gamming_community/view/notfications/provider/notification_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class FriendRequestTab extends StatelessWidget {
  final FRefreshController fRefreshController = FRefreshController();
  final double bannerHeight = 60;

  Widget buildUnAcceptBanner() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Container(
        height: bannerHeight,
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                colors: [Color(0xffaa4b6b), Color(0xff6b6b83), Color(0xff3b8d99)],
                tileMode: TileMode.clamp)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FeatherIcons.userCheck),
            SizedBox(width: 10),
            Text("Unaccept request", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            Spacer(),
            Text(
              "2",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WhenRebuilderOr<NotificationProvider>(
        //initState: (_, model) => model.setState((s) => s.loadFriendRequest()),
        watch: (model) => model.state.friendsRequest,
        observe: () => RM.get<NotificationProvider>(),
        onWaiting: () => Center(child: AppConstraint.loadingIndicator(context)),
        
        builder: (context, model) => Column(
              children: [
                buildUnAcceptBanner(),
                Flexible(
                  //   width: Get.width,
                  //    height: Get.height - bannerHeight,
                  child: FRefresh(
                      controller: fRefreshController,
                      headerHeight: 60,
                      headerBuilder: (setter, constraints) {
                        return CustomHeaderFRefresh();
                      },
                      footerHeight: 50.0,
                      footerBuilder: (setter) {
                        return CustomFooterFRefresh();
                      },
                      onRefresh: () async {
                        print("on refresh");
                        await model
                            .setState((s) => s.loadFriendRequest())
                            .then((value) => fRefreshController.finishRefresh());
                      },
                      onLoad: () {
                        print("onLoad");
                        fRefreshController.finishLoad();
                      },
                      child:  model.state.countfriendRequest == 0
                              ? Container(
                                  width: Get.width,
                                  height: Get.height - bannerHeight * 3,
                                  child: Center(child: Text("No friend request.")),
                                )
                              : ListView.separated(
                                  separatorBuilder: (context, index) => Divider(),
                                  itemCount: model.state.countfriendRequest,
                                  itemBuilder: (context, index) {
                                    var requests = model.state.friendsRequest;
                                    return Container(
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
                                            SizedBox(width: 10),
                                            Text(requests[index].name)
                                          ]),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    NotificationServices.acceptRequest(
                                                        int.parse(requests[index].senderID), true);
                                                  },
                                                  child: Text("Accept")),
                                              FlatButton(
                                                  onPressed: () {
                                                    NotificationServices.acceptRequest(
                                                        int.parse(requests[index].senderID), false);
                                                  },
                                                  child: Text("Dismiss"))
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ))),
                
              ],
            ));
  }
}
