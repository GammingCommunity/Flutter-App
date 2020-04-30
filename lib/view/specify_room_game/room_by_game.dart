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
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/utils/progress_button.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/view/profile/settingProvider.dart';
import 'package:gamming_community/view/room/provider/room_list_provider.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/specify_room_game/join_button.dart';
import 'package:gamming_community/view/specify_room_game/roomItem.dart';
import 'package:gamming_community/view/specify_room_game/sortButton.dart';
import 'package:gamming_community/view/specify_room_game/sortChip.dart';
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

class _RoomByGameState extends State<RoomByGame> with TickerProviderStateMixin {
  GraphQLQuery query = GraphQLQuery();
  RoomsProvider roomsProvider;
  SettingProvider settingProvider;
  ScrollController scrollController;
  AnimationController controller;
  AnimationController _animationController;
  Animation _curve;
  Animation<RelativeRect> _animation;
  bool isPress = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await roomsProvider.initLoad(widget.gameID, "none");
    });
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _curve = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);

    _animation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(0, 0, 0, 0), end: RelativeRect.fromLTRB(0, 50, 0, 0))
        .animate(_curve);

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    roomsProvider = Injector.get(context: context);
    settingProvider = Injector.get(context: context);
    final screenSize = MediaQuery.of(context).size;
    var rooms = roomsProvider.rooms;
    return Hero(
      tag: widget.gameID,
      child: Scaffold(
          appBar: CustomAppBar(
              padding: EdgeInsetsResponsive.only(right: 10),
              child: [
                Text(widget.gameName, style: TextStyle(fontSize: 20)),
                Spacer(),
                SortButton(
                  onSelected: (value) {
                    value ? _animationController.forward() : _animationController.reverse();
                  },
                ),
              ],
              height: 40,
              onNavigateOut: () {
                Navigator.pop(context);
                roomsProvider.clear();
              },
              backIcon: FeatherIcons.arrowLeft),
          body: RefreshIndicator(
            onRefresh: () {
              return roomsProvider.refresh(roomsProvider.groupSize);
            },
            child: Container(
              height: screenSize.height,
              width: screenSize.width,
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 50,
                      color: Colors.grey,
                      child: SortChip(onSelected: (value) {
                        if (value == "small")
                          return roomsProvider.refresh("small");
                        else if (value == "large") return roomsProvider.refresh("large");
                        return roomsProvider.refresh("none");
                      })),
                  PositionedTransition(
                    rect: _animation,
                    child: Container(
                        height: screenSize.height,
                        width: screenSize.width,
                        padding: EdgeInsetsResponsive.only(top: 10),
                        color:
                            settingProvider.darkTheme ? AppColors.BACKGROUND_COLOR : Colors.white,
                        child: rooms.isEmpty
                            ? Center(
                                child: AppConstraint.spinKitCubeGrid(context),
                              )
                            : ListView.separated(
                                addAutomaticKeepAlives: true,
                                controller: scrollController,
                                physics: AlwaysScrollableScrollPhysics(),
                                separatorBuilder: (context, index) => FaSlideAnimation(
                                    show: true, delayed: 200, child: Divider(thickness: 1)),
                                itemCount: roomsProvider.rooms.length,
                                itemBuilder: (context, index) {
                                  return index >= roomsProvider.rooms.length
                                      ? buildLoadMore()
                                      : RoomItem(room: rooms[index]);
                                })),
                  ),
                ],
              ),
            ),
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
