/*Fecth Room which user is Host, host user will able to modify , such as edit, remove, kick mem, add mem, ... */

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/customWidget/PVScaleFactor.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/group_dashboard/group_dashboard.dart';
import 'package:gamming_community/view/room/create_room_v2.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/room_manager/edit_room.dart';
import 'package:gamming_community/view/room_manager/logo_room.dart';
import 'package:get/get.dart' as gets;
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RoomManager extends StatefulWidget {
  @override
  _RoomManagerState createState() => _RoomManagerState();
}

class _RoomManagerState extends State<RoomManager> with AutomaticKeepAliveClientMixin {
  RoomManagerBloc roomManagerBloc;
  GraphQLQuery query = GraphQLQuery();
  var _value = 0;
  var _tapPosition;
  Completer<void> _refreshCompleter;

  void _showCustomMenu(int roomIndex, String roomID) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
            context: context,
            items: <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 1,
                child: Text("Edit"),
              ),
              PopupMenuItem(value: 2, child: Text("Remove"))
            ],
            position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Offset.zero & overlay.size // Bigger rect, the entire screen
                ))
        .then<void>((int position) {
      if (position == null) return;

      setState(() {
        doWork(position, roomIndex, roomID);
      });
    });
  }

  void doWork(int type, int roomIndex, String roomID) {
    switch (type) {
      case 1:
        Get.to(
            EditRoom(
              roomID: roomID,
            ),
            transition: gets.Transition.leftToRightWithFade);
        break;
      case 2:
        roomManagerBloc.add(RemoveRoom(index: roomIndex));
        break;
      default:
    }
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    roomManagerBloc = BlocProvider.of<RoomManagerBloc>(context);
    roomManagerBloc.add(InitLoading());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double itemHeight = (Get.height - kToolbarHeight) / 2.6.h;
    final double itemWidth = ScreenUtil().uiWidthPx / 2.w;
    var rooms = roomManagerBloc.room;
    var currentID = roomManagerBloc.currentID;
    super.build(context);
    return BlocListener<RoomManagerBloc, RoomManagerState>(
      condition: (previous, current) {
        if (previous is AddRoomLoading) {
          Navigator.pop(context);
        }
        return true;
      },
      listener: (context, state) {
        if (state is AddRoomLoading) {
          openLoadingDialog(context, "");
        }
        if (state is AddRoomFail) {
          Navigator.pop(context);
          openLoadingDialog(context, "Create fail.");
        }

        if (state is RefreshSuccess) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }

        if (state is AddRoomSuccess) {
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Create success"),
          ));
        }
        if (state is RemoveRoomSuccess) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Remove success")));
        }
        if (state is RemoveRoomFailed) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text("Can not delete, try again.")));
        }
      },
      child: BlocBuilder<RoomManagerBloc, RoomManagerState>(builder: (context, state) {
        if (state is RoomManagerInitial) {
          return AppConstraint.loadingIndicator(context);

          //AppConstraint.spinKitCubeGrid(context);
        }
        if (state is InitFail) {
          return buildException(context);
        }
        if (state is AddRoomFail) {}

        return Scaffold(
            floatingActionButton: FloatingActionButton(
                heroTag: "addNewGroup",
                child: Icon(FeatherIcons.plus),
                onPressed: () {
                  gets.Get.to(CreateRoomV2(), transition: gets.Transition.fade);
                  /*Navigator.push(context,
                      PageTransition(child: , type: PageTransitionType.fade));*/
                }),
            body: RefreshIndicator(
              onRefresh: () {
                roomManagerBloc.add(RefreshRooms());
                return _refreshCompleter.future;
              },
              child: PVScaleFactor(
                child: ContainerResponsive(
                  height: screenSize.height,
                  width: screenSize.width,
                  margin: EdgeInsetsResponsive.only(top: 10),
                  alignment: Alignment.center,
                  child: GridView.builder(
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 20, vertical: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 30.w,
                        crossAxisCount: 2,
                        mainAxisSpacing: 30.h,
                        childAspectRatio: itemWidth / itemHeight),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      return FaSlideAnimation.slideUp(
                        show: true,
                        delayed: 0,
                        child: Material(
                          color: Theme.of(context).backgroundColor,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(15),
                          elevation: 2,
                          child: InkWell(
                            onTap: () {
                              gets.Get.to(
                                  /*RoomDetailV2(
                                    room: rooms[index],
                                    itemTag: rooms[index].id,
                                  ),*/
                                  GroupDashboard(
                                      room: rooms[index],
                                      currenID: roomManagerBloc.currentID,
                                      member: rooms[index].memberID),
                                  transition: gets.Transition.cupertino,
                                  opaque: false);
                            },
                            // long press on each room
                            onLongPress: () {
                              _showCustomMenu(index, rooms[index].id);
                            },
                            onTapDown: _storePosition,
                            child: ContainerResponsive(
                              height: 150.h,
                              width: 100.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      //background room (default, if spectify, display here)
                                      rooms[index].roomBackground == ""
                                          ? ContainerResponsive(
                                              alignment: Alignment.center,
                                              height: 100.h,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image:
                                                          AssetImage(AppConstraint.noImageAsset)),
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(15),
                                                      topRight: Radius.circular(15))),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: rooms[index].roomBackground,
                                              width: Get.width,
                                              fit: BoxFit.cover,
                                              height: 100.h,
                                            ),

                                      SizedBox(
                                        height: 30,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsetsResponsive.symmetric(
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              rooms[index].roomName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ScreenUtil().setSp(15)),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          TextResponsive("${rooms[index].memberID.length} member"),
                                          // display some member in room
                                          Padding(
                                            padding: EdgeInsetsResponsive.all(5),
                                            child: DisplayMember(
                                                showBadged: true,
                                                borderRadius: 1000,
                                                size: 30,
                                                ids: rooms[index].memberID),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: CircleIcon(
                                        icon: FeatherIcons.moreVertical,
                                        iconSize: 20,
                                        onTap: () {
                                          // show menu here
                                        },
                                      )),
                                  Positioned(
                                      top: 70.h,
                                      left: 20.w,
                                      child: //logo room
                                          LogoRoom(url: rooms[index].roomLogo)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
      }),
    );
  }

  Widget buildException(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton.icon(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                //(context as Element).reassemble();
                roomManagerBloc.add(InitLoading());
              });
            },
            icon: Icon(Icons.refresh),
            label: Text("Refresh"))
      ],
    );
  }

  Future buildAddRoomFail(BuildContext context, String message) async {
    return Get.dialog(Center(
        child: Container(
            color: Colors.black, height: 50, width: 50, child: Text("Create room fail"))));
  }

  Future openLoadingDialog(BuildContext context, String message) {
    return Get.dialog(
      message == ""
          ? Center(child: Container(height: 50, width: 50, child: CircularProgressIndicator()))
          : Text(message),
    );
  }

  Widget showOptionMenu() {
    return PopupMenuButton<int>(
      tooltip: "Menu",
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text("Edit room"),
          value: 1,
        ),
        PopupMenuDivider(
          height: 10,
        ),
        PopupMenuItem(
          child: Text("Remove room"),
          value: 2,
        )
      ],
      onSelected: (value) {
        print("value:$value");
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
