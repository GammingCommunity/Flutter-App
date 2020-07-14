import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customFooterFRefresh.dart';
import 'package:gamming_community/customWidget/customHeaderFRefresh.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/notfications/provider/notification_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:timeago/timeago.dart' as timeago;

class PendingJoinTab extends StatelessWidget {
  final FRefreshController fRefreshController = FRefreshController();

  String timeUntil(DateTime date) {
    return timeago.format(date, locale: 'en', allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    return WhenRebuilderOr<NotificationProvider>(
        watch: (model) => model.state.pending,
        observe: () => RM.get<NotificationProvider>(),
        //initState: (_, model) => model.setState((s) => s.loadPendingRequest()),
        onWaiting: () => Center(
              child: AppConstraint.loadingIndicator(context),
            ),
        builder: (context, model) => FRefresh(
              controller: fRefreshController,
              headerHeight: 60,
              headerBuilder: (setter, constraints) {
                //await _privateChatProvider.refresh();
                return CustomHeaderFRefresh();
              },
              footerHeight: 50.0,
              footerBuilder: (setter) {
                /// Get refresh status, partially update the content of Footer area

                return CustomFooterFRefresh();
              },
              onRefresh: () async {
                print("on refresh");
                model
                    .setState((s) => s.loadPendingRequest())
                    .then((value) => fRefreshController.finishRefresh());
              },
              onLoad: () {
                print("onLoad");
                fRefreshController.finishLoad();
              },
              child: Container(
                  height: Get.height,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: Get.width,
                  child: model.state.countjoinRoomPending == 0
                      ? Center(child: Text("No pending request"))
                      : ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: model.state.countjoinRoomPending,
                          itemBuilder: (context, index) {
                            var pendingRequest = model.state.pending;
                            return Container(
                              height: 100,
                              width: Get.width,
                              child: Row(
                                children: [
                                  FutureBuilder(
                                    future: Future(() async {
                                      var query = GraphQLQuery();
                                      return SubRepo.queryGraphQL(
                                          await getToken(),
                                          query.getMutliUserInfo(
                                              toListInt([pendingRequest[index].userID])));
                                    }),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SkeletonTemplate.image(50, 50, 15),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                SkeletonTemplate.text(10, Get.width / 2.5, 15),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SkeletonTemplate.text(10, Get.width / 3, 15)
                                              ],
                                            )
                                          ],
                                        );
                                      } else {
                                        final currentTime = new DateTime.now();
                                        var userInfo =
                                            ListUser.fromJson(snapshot.data.data['lookAccount'])
                                                .listUser[0];
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: userInfo.profileUrl ??
                                                      AppConstraint.default_profile),
                                            ),
                                            SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(userInfo.nickname),
                                                    Text(
                                                        "${timeago.format(currentTime.subtract(new Duration(minutes: pendingRequest[index].joinTime.minute)), locale: 'en')}")
                                                  ],
                                                ),
                                                Flexible(
                                                    child: Text(
                                                  "want to join AAA",
                                                  overflow: TextOverflow.ellipsis,
                                                ))
                                              ],
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                  Spacer(),
                                  Row(
                                    children: <Widget>[
                                      CircleIcon(icon: FeatherIcons.check, onTap: () {}),
                                      CircleIcon(icon: FeatherIcons.x, onTap: () {})
                                    ],
                                  )
                                ],
                              ),
                            );
                          })),
            ));
  }
}
