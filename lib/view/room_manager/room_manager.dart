/*Fecth Room which user is Host, host user will able to modify , such as edit, remove, kick mem, add mem, ... */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/utils/jwt_decode.dart';
import 'package:gamming_community/view/home/home.dart';
import 'package:gamming_community/view/room/create_room.dart';
import 'package:gamming_community/view/room/create_room_v2.dart';
import 'package:gamming_community/view/room/explorer_room.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/room_manager/logo_room.dart';
import 'package:gamming_community/view/room_manager/room_detail.dart';
import 'package:gamming_community/view/room_manager/room_detail_v2.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomManager extends StatefulWidget {
  final String token;
  RoomManager({this.token});
  @override
  _RoomManagerState createState() => _RoomManagerState();
}

class _RoomManagerState extends State<RoomManager> with AutomaticKeepAliveClientMixin {
  RoomManagerBloc roomManagerBloc;
  GraphQLQuery query = GraphQLQuery();
  List<String> userInfo = [];
  List<String> sampleUser = [
    "https://api.adorable.io/avatars/90/abott@adorable.io.png",
    "https://api.adorable.io/avatars/90/magic.png",
    "https://api.adorable.io/avatars/90/closer.png"
  ];
  var _count = 0;
  var _tapPosition;
  Future getInfo() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    List<String> res = refs.getStringList("userToken");
    //TODO: print("$res here");
    userInfo = res;

    return res;
  }

  void _showCustomMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
            context: context,
            items: <PopupMenuEntry<int>>[
              PopupMenuItem(child: Text("Edit")),
              PopupMenuItem(child: Text("Remove"))
            ],
            position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Offset.zero & overlay.size // Bigger rect, the entire screen
                ))
        .then<void>((int delta) {
      if (delta == null) return;

      setState(() {
        _count = _count + delta;
      });
    });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  void initState() {
    roomManagerBloc = BlocProvider.of<RoomManagerBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var userID = jwtDecode(widget.token).toString();
    final double itemHeight = (ScreenUtil().uiHeightPx - kToolbarHeight - 24) / 2.5.h;
    final double itemWidth = ScreenUtil().uiWidthPx / 2.w;
    var brightness = MediaQuery.of(context).platformBrightness;

    super.build(context);
    return BlocListener<RoomManagerBloc, RoomManagerState>(
      listener: (context, state) {
        if (state is CreateRoom) {}
        if (state is RemoveRoom) {}
      },
      child: BlocBuilder<RoomManagerBloc, RoomManagerState>(builder: (context, state) {
        return GraphQLProvider(
            client: customClient(widget.token),
            child: CacheProvider(
                child: Scaffold(
                    floatingActionButton: FloatingActionButton(
                        heroTag: "addNewGroup",
                        child: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(context,
                              PageTransition(child: CreateRoomV2(), type: PageTransitionType.fade));
                        }),
                    body: ContainerResponsive(
                        margin: EdgeInsetsResponsive.only(top: 10),
                        alignment: Alignment.center,
                        child: Query(
                            options:
                                QueryOptions(documentNode: gql(query.getRoomCurrentUser(userID))),
                            builder: (QueryResult result,
                                {VoidCallback refetch, FetchMore fetchMore}) {
                              if (result.loading) {
                                return AppConstraint.spinKitCubeGrid(context);
                              }
                              if (result.hasException) {
                                return buildException(context);
                              } else {
                                var rooms = Rooms.fromJson(result.data['roomManage']).rooms;
                                return ContainerResponsive(
                                  height: ScreenUtil().uiHeightPx,
                                  width: ScreenUtil().uiWidthPx,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 30.w,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 30.h,
                                        childAspectRatio: itemWidth / itemHeight),
                                    itemCount: rooms.length,
                                    itemBuilder: (context, index) {
                                      return Material(
                                        color:  Theme.of(context).dialogTheme.backgroundColor ,
                                        clipBehavior: Clip.antiAlias,
                                        borderRadius: BorderRadius.circular(15),
                                        elevation: 2,
                                        child: InkWell(
                                          onTap: () {
                                            print(index);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => RoomDetailV2(
                                                          room: rooms[index],
                                                          itemTag: rooms[index].id,
                                                        )));
                                          },
                                          // long press on each room
                                          onLongPress: () {
                                            _showCustomMenu();
                                          },
                                          onTapDown: _storePosition,
                                          child: ContainerResponsive(
                                            height: 150.h,
                                            width: 100.w,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15)),
                                            child: Stack(
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    //background room (default, if spectify, display here)
                                                    ContainerResponsive(
                                                      alignment: Alignment.center,
                                                      height: 100.h,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  AppConstraint.noImageAsset)),
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(15),
                                                              topRight: Radius.circular(15))),
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
                                                                fontSize: 20),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        Text(
                                                            "${rooms[index].memberID.length} member"),
                                                        // display some member in room
                                                        Padding(
                                                          padding: EdgeInsetsResponsive.all(5),
                                                          child: DisplayMember(
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
                                                      onTap: () {},
                                                    )),
                                                Positioned(
                                                    top: 70.h,
                                                    left: 20.w,
                                                    child: //logo room
                                                        LogoRoom(
                                                            url:
                                                                "https://via.placeholder.com/150")),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            })))));
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildException(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Image.asset('assets/images/no_image.png'),
      FlatButton.icon(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              (context as Element).reassemble();
            });
          },
          icon: Icon(Icons.refresh),
          label: Text("Refresh"))
    ],
  );
}
