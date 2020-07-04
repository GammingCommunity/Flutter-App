import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/class/CountRoom.dart';
import 'package:gamming_community/controller/explorerController.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/room/provider/explorerProvider.dart';
import 'package:gamming_community/view/specify_room_game/room_by_game.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Explorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ExplorerController>(
        autoRemove: false,
        init: ExplorerController(),
        builder: (e) => Scaffold(
                body: Container(
              padding: EdgeInsetsResponsive.all(10),
              height: Get.height,
              width: Get.width,
              child: WhenRebuilder<ExploreProvider>(
                observe: () => RM.get<ExploreProvider>(),
                initState: (context, explorerProvider) =>
                    explorerProvider.setState((s) => s.init()),
                onIdle: null,
                onWaiting: () => AppConstraint.loadingIndicator(context),
                onError: (error) => Text(error),
                onData: (data) => FRefresh(
                    controller: e.fRefreshController,
                    headerHeight: 70,
                    headerBuilder: (setter, constraints) {
                      //await _privateChatProvider.refresh();
                      return buildHeader();
                    },
                    footerHeight: 60.0,
                    footerBuilder: (setter) {
                      return buildFooter();
                    },
                    onRefresh: () async {
                      print("on refresgh");
                      await data.refresh();
                      e.fRefreshController.finishRefresh();
                    },
                    onLoad: () {
                      print("onLoad");
                      Timer(Duration(milliseconds: 3000), () {
                        e.fRefreshController.finishLoad();
                        print(
                            'controller4.position = ${e.fRefreshController.position}, controller4.scrollMetrics = ${e.fRefreshController.scrollMetrics}');
                      });
                    },
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (ctx, index) => SizedBox(
                        height: 20,
                      ),
                      shrinkWrap: true,
                      itemCount: data.gameChanelLength,
                      itemBuilder: (context, index) {
                        var rooms = data.rooms;

                        return Hero(tag: index, child: buildItem(context, rooms[index]));
                      },
                    )),
              ),
            )));
  }
}

Widget buildItem(BuildContext context, Room rooms) {
  return Material(
    borderRadius: BorderRadius.circular(15),
    elevation: 4,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () {
        Get.to(
            RoomByGame(
              gameID: rooms.id,
              gameName: rooms.gameName,
            ),
            transition: Transition.leftToRightWithFade);
      },
      child: ContainerResponsive(
        width: Get.width,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: rooms.background,
                placeholder: (context, url) => Container(
                  height: 110,
                  color: Colors.grey[300],
                ),
              ),
            ),
            Positioned(
                left: 30,
                top: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextResponsive(
                      "${rooms.gameName}",
                      style: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 3))
                          ],
                          fontSize: AppConstraint.roomTitleSize),
                    ),
                    TextResponsive(
                      "${rooms.count} room",
                      style: TextStyle(color: Colors.white, fontSize: AppConstraint.roomTitleSize),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

Widget buildHeader() {
  return Container(
    height: 50,
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        backgroundColor: Color(0xfff1f3f6),
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
        strokeWidth: 2.0,
      ),
    ),
  );
}

Widget buildFooter() {
  return Container(
      height: 40,
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
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
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
}
/*
class Explorer extends StatefulWidget {
  final String token;
  Explorer({this.token});
  @override
  _SummaryRoomState createState() => _SummaryRoomState();
}

class _SummaryRoomState extends State<Explorer> {
  GraphQLQuery query = GraphQLQuery();
  ScrollController scrollController;
  double scrollPosition;

  @override
  void initState() {
    print("init explorer room");
    scrollController = ScrollController();
    scrollController.addListener(() {
      setState(() {
        scrollPosition = scrollController.position.pixels;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ContainerResponsive(
        padding: EdgeInsetsResponsive.all(10),
        height: Get.height,
        width: Get.width,
        child: WhenRebuilderOr<ExploreProvider>(
            initState: (_,explorerProvider ) => explorerProvider.future((s, stateAsync) => s.init()),
            observe: () => RM.get<ExploreProvider>(),
            builder: (context, explorerModel) {
              return explorerModel.whenConnectionState(
                onIdle: null,
                onWaiting: () => AppConstraint.loadingIndicator(context),
                onError: (error) => buildException(context),
                onData: (explorerModel) {
                  var rooms = explorerModel.rooms;
                  return ContainerResponsive(
                    child: NotificationListener(
                      onNotification: (notification) {
                        /* if (notification is ScrollUpdateNotification) {
                              search.setCurrentScrollOffset(scrollPosition);
                            }
                            /*print("current scroll position" + scrollPosition.toString());
                              print(search.currentOffset);*/

                            if (scrollPosition == 0.0 && scrollPosition < 100) {
                              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                search.setHideSearchBar(true);
                              });
                            }
                            if (search.currentOffset > 100) {
                              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                                search.setHideSearchBar(false);
                              });
                            }*/
                      },
                      child: ListView.separated(
                        //controller: scrollController,

                        addAutomaticKeepAlives: true,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return Hero(
                              tag: rooms[index].id, child: buildItem(context, rooms, index));
                        },
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }

}

Widget buildException(BuildContext context) {
  return Align(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                (context as Element).reassemble();
              }),
          Text("Error during fetch, try again")
        ],
      ));
}

Widget buildItem(BuildContext context, List<Room> rooms, int index) {
  return Material(
    borderRadius: BorderRadius.circular(15),
    elevation: 4,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomByGame(
                      gameID: rooms[index].id,
                      gameName: rooms[index].gameName,
                    )));
      },
      child: ContainerResponsive(
        width: ScreenUtil().uiWidthPx,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: rooms[index].background,
                placeholder: (context, url) => Container(
                  height: 110,
                  color: Colors.grey[300],
                ),
              ),
            ),
            Positioned(
                left: 30,
                top: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextResponsive(
                      "${rooms[index].gameName}",
                      style: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 6, color: Colors.black, offset: Offset(2, 3))
                          ],
                          fontSize: AppConstraint.roomTitleSize),
                    ),
                    TextResponsive(
                      "${rooms[index].count} room",
                      style: TextStyle(color: Colors.white, fontSize: AppConstraint.roomTitleSize),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

Widget itemLoading(double width) {
  return ListView.separated(
    separatorBuilder: (context, index) => SizedBox(
      height: 20,
    ),
    itemCount: 10,
    // Important code
    itemBuilder: (context, index) => SizedBox(
        height: 120,
        width: width,
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.only(left: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 15,
                width: 100,
                decoration:
                    BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(height: 10),
              Container(
                height: 15,
                width: 100,
                decoration:
                    BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(15)),
              ),
            ],
          ),
        )),
  );
}
*/
