import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/faslideAnimation.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/progress_button.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/view/room/provider/room_list_provider.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/specify_room_game/join_button.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomByGame extends StatefulWidget {
  final String gameID, token;
  final String gameName;
  RoomByGame({this.gameID, this.gameName, this.token});
  @override
  _RoomByGameState createState() => _RoomByGameState();
}

class _RoomByGameState extends State<RoomByGame> {
  GraphQLQuery query = GraphQLQuery();
  RoomsProvider roomsProvider;
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await roomsProvider.initLoad(widget.gameID);
    });
    scrollController = ScrollController()
      ..addListener(() {
        loadMore();
      });
  }

  void loadMore() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      print("here");
      roomsProvider.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    roomsProvider = Injector.get(context: context);
    final screenSize = MediaQuery.of(context).size;
    var rooms = roomsProvider.rooms;
    return Hero(
      tag: widget.gameID,
      child: Scaffold(
          appBar: CustomAppBar(
              child: [
                Text(widget.gameName, style: TextStyle(fontSize: 20)),
                Spacer(),
                CircleIcon(
                  icon: FeatherIcons.chevronDown,
                  iconSize: 20,
                  onTap: () {
                    // show panel below appbar
                  },
                )
              ],
              height: 40,
              onNavigateOut: () {
                Navigator.pop(context);
                roomsProvider.clear();
              },
              backIcon: FeatherIcons.arrowLeft),
          body: RefreshIndicator(
            onRefresh: () {
              return roomsProvider.refresh();
            },
            child: Container(
                height: screenSize.height,
                width: screenSize.width,
                child: rooms.isEmpty
                    ? Center(
                        child: AppConstraint.spinKitCubeGrid(context),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        physics: AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => FaSlideAnimation(
                            show: true, delayed: 200, child: Divider(thickness: 1)),
                        itemCount: roomsProvider.rooms.length,
                        itemBuilder: (context, index) {
                          var v = DateTime.now()
                              .difference(DateTime.tryParse(rooms[index].createAt).toLocal());
                          return index >= roomsProvider.rooms.length
                              ? buildLoadMore()
                              : FaSlideAnimation(
                                  show: true,
                                  delayed: 100,
                                  child: InkWell(
                                    onTap: () {},
                                    child: ContainerResponsive(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConstraint.container_border_radius)),
                                      width: screenSize.width,
                                      height: 100,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsetsResponsive.symmetric(horizontal: 5),
                                            child: Stack(
                                              children: <Widget>[
                                                //logo room
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        height: 60.h,
                                                        width: 60.w,
                                                        //fadeInCurve: Curves.easeIn,
                                                        fadeInDuration: Duration(seconds: 2),
                                                        imageUrl: rooms[index].roomLogo,
                                                        placeholder: (context, url) =>
                                                            SkeletonTemplate.image(
                                                                60.h, 60.w, 1000, Colors.grey),
                                                        errorWidget: (context, url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // room information
                                                Positioned(
                                                  left: 80,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Wrap(
                                                        direction: Axis.vertical,
                                                        spacing: 10,
                                                        runAlignment: WrapAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            rooms[index].roomName ?? "Room name",
                                                            style: TextStyle(
                                                                fontSize: ScreenUtil().setSp(18)),
                                                          ),
                                                          Align(
                                                              alignment: Alignment.centerLeft,
                                                              child:
                                                                  Text("${v.inHours} hours ago")),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              DisplayMember(
                                                                borderRadius: 1000,
                                                                size: 30,
                                                                ids: rooms[index].memberID,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: ContainerResponsive(
                                                      height: 30.h,
                                                      alignment: Alignment.center,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.indigo,
                                                          borderRadius: BorderRadius.circular(15)),
                                                      child: Text(
                                                          "${rooms[index].memberID.length}/ ${rooms[index].maxOfMember}")),
                                                )
                                              ],
                                            ),
                                          ),
                                          Positioned.fill(
                                              child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: ProgressButtons(
                                              setCircle: true,
                                              buttonHeight: 30,
                                              buttonWidth: 60,
                                              isJoin: rooms[index].isJoin,
                                              isRequest: rooms[index].isRequest,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Icon(
                                                    FeatherIcons.plus,
                                                    size: 15,
                                                  ),
                                                  Text("Join")
                                                ],
                                              ),
                                              info: {
                                                "hostID": rooms[index].hostID,
                                                "roomID": rooms[index].id
                                              },
                                              onPressed: () {},
                                              onSuccess: (value) {
                                                value == 1 ??
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback((timeStamp) {
                                                      return showResultDialog(
                                                          context, "Wait for approve.");
                                                    });
                                              },
                                              onError: (value) {
                                                print("join room err : $value");
                                              },
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                        })),
          )),
    );
  }
}

Widget buildLoadMore() {
  return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ));
}

showResultDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) => ContainerResponsive(
        height: 150.h,
        width: 200.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SimpleDialog(
          children: <Widget>[
            Icon(
              FeatherIcons.checkCircle,
              size: 30,
            ),
            SizedBoxResponsive(height: 10),
            Align(alignment: Alignment.center, child: Text(content)),
          ],
        )),
  );
}
