/*Fecth Room which user is Host, host user will able to modify , such as edit, remove, kick mem, add mem, ... */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/room/create_room.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomManager extends StatefulWidget {
  @override
  _RoomManagerState createState() => _RoomManagerState();
}

class _RoomManagerState extends State<RoomManager>
    with AutomaticKeepAliveClientMixin {
  RoomManagerBloc roomManagerBloc;
  Config config = Config();
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

    // Another option:
    //
    // final delta = await showMenu(...);
    //
    // Then process `delta` however you want.
    // Remember to make the surrounding function `async`, that is:
    //
    // void _showCustomMenu() async { ... }
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
    super.build(context);
    return BlocListener<RoomManagerBloc, RoomManagerState>(
      listener: (context, state) {
        if (state is CreateRoom) {}
        if (state is RemoveRoom) {}
      },
      child: BlocBuilder<RoomManagerBloc, RoomManagerState>(
        builder: (context, state) {
          return GraphQLProvider(
            client: config.client,
            child: CacheProvider(
              child: Scaffold(
                body: Container(
                    alignment: Alignment.center,
                    child: FutureBuilder(
                        future: getInfo(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Align(
                              alignment: Alignment.center,
                              child: SpinKitSquareCircle(
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          } else
                            return Query(
                                options: QueryOptions(
                                    documentNode: gql(query
                                        .getRoomCurrentUser(snapshot.data[1]))),
                                builder: (QueryResult result,
                                    {VoidCallback refetch,
                                    FetchMore fetchMore}) {
                                  if (result.loading) {
                                    return Align(
                                      alignment: Alignment.topCenter,
                                      child: SpinKitSquareCircle(
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    );
                                  }
                                  if (result.data.values.first == 0 ||
                                      result.hasException) {
                                    return AnimatedContainer(
                                        duration: Duration(seconds: 10),
                                        curve: Curves.bounceInOut,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            "assets/icons/empty_icon.svg"));
                                  } else {
                                    return FutureBuilder<List<Room>>(
                                        future: ListRoom.getList(result.data['roomManage']),
                                        builder: (context, snapshot) {
                                          
                                          if(snapshot.connectionState ==ConnectionState.waiting){
                                            return AppConstraint.spinKitCubeGrid;
                                          }
                                          else {
                                            var r = snapshot.data;
                                            return Container(
                                              height: screenSize.height,
                                              width: screenSize.width,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40),
                                              child: Material(
                                                color: Colors.transparent,
                                                type: MaterialType.card,
                                                child: GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: 30,
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 30,
                                                    childAspectRatio:
                                                        (screenSize.width / 2) /
                                                            ((screenSize
                                                                    .height) /
                                                                3),
                                                  ),
                                                  itemCount: r.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      splashColor: Colors.black,
                                                      onTap: () {
                                                        print(index);
                                                      },
                                                      // long press on each room
                                                      onLongPress: () {
                                                        _showCustomMenu();
                                                      },
                                                      onTapDown: _storePosition,
                                                      child: Container(
                                                        height: 200,
                                                        width: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                //background room (default, if spectify, display here)
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height: 100,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              15),
                                                                          topRight:
                                                                              Radius.circular(15))),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Wrap(
                                                                  spacing: 10,
                                                                  runSpacing: 5,
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Flexible(
                                                                            fit:
                                                                                FlexFit.loose,
                                                                            child: Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Text(
                                                                                r[index].roomName,
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                        "${r[index].memberID.length} member"),
                                                                    // display some member in room
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        for (var item
                                                                            in r[index].memberID)
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(1000),
                                                                            child:
                                                                                CachedNetworkImage(
                                                                              imageUrl: AppConstraint.default_profile,
                                                                              height: 30,
                                                                              width: 30,
                                                                              fit: BoxFit.cover,
                                                                              placeholder: (context, image) => SpinKitCubeGrid(color: Colors.white, size: 10),
                                                                              errorWidget: (context, error, image) => Icon(Icons.error),
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Positioned(
                                                                top: 5,
                                                                right: 5,
                                                                child: Material(
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  type: MaterialType
                                                                      .circle,
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      IconButton(
                                                                    icon: Icon(Icons
                                                                        .more_vert),
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                )),
                                                            Positioned(
                                                              top: 50,
                                                              left: 50,
                                                              child: //logo room
                                                                  CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://via.placeholder.com/150",
                                                                imageBuilder:
                                                                    (context,
                                                                        imageProvider) {
                                                                  return Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    height: 80,
                                                                    width: 80,
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.black, width: 2),
                                                                        shape: BoxShape.circle,
                                                                        image: DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                                  );
                                                                },
                                                                placeholder: (context,
                                                                        url) =>
                                                                    SpinKitChasingDots(
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            20),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ));
                                          }
                                        });
                                  }
                                });
                        })),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
