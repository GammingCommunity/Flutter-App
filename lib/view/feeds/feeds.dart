// feed cho user
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/feeds/provider/feedsProvider.dart';
import 'package:gamming_community/view/feeds/userPost.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Feeds extends StatefulWidget {
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    print("feeds init");
    super.initState();
  }

  void _onRefresh(FeedsProvider feedsProvider) async {
    // monitor network fetch
    // if failed,use refreshFailed()
    //await feedsProvider.refresh();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
          height: ScreenUtil().uiHeightPx,
          width: ScreenUtil().uiWidthPx,
          padding: EdgeInsets.all(10),
          child: WhenRebuilderOr<FeedsProvider>(
            observe: () => RM.get<FeedsProvider>(),
            initState: (context, feedsProvider) => feedsProvider.setState((s) => s.init()),
            builder: (context, model) {
              return model.whenConnectionState(
                  onIdle: null,
                  onWaiting: () => AppConstraint.loadingIndicator(context),
                  onError: (error) => buildException(context),
                  onData: (data) {
                    var posts = data.posts;
                    return SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (BuildContext context, LoadStatus mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = Text("pull up load");
                          } else if (mode == LoadStatus.loading) {
                            body = CircularProgressIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = Text("release to load more");
                          } else {
                            body = Text("No more Data");
                          }
                          return Container(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: () => _onRefresh(data),
                      onLoading: ()=> _onLoading(),
                      child: ListView.builder(
                        itemBuilder: (c, i) {
                          return UserPost(
                            post: posts[i],
                          );
                        },
                        itemCount: posts.length,
                      ),
                    );
                  });
            },
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildException(BuildContext context) {
  return Container(
    height: 50,
    width: ScreenUtil().uiWidthPx,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Fail to load post, try again."),
        CircleIcon(
          icon: FeatherIcons.rotateCw,
          iconSize: 20,
          onTap: () {
            void rebuild(Element el) {
              el.markNeedsBuild();
              el.visitChildren(rebuild);
            }
             (context as Element).visitChildren(rebuild);
          },
        )
      ],
    ),
  );
}
