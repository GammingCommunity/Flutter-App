import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/provider/fetchMore.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/room/create_room.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
 
int page = 1 ;
class RoomList extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<RoomList>
    with AutomaticKeepAliveClientMixin<RoomList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isJoin = false;
  GraphQLQuery query = GraphQLQuery();
  Config config = Config();
  List<Room> room = [];
   int page = 1 ;
   int limit = 5;
 
  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    // monitor network fetch
    //print("refresh");
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    page=1;
    SharedPreferences refs = await SharedPreferences.getInstance();
    List<String> res = refs.getStringList("userToken");
    GraphQLClient client = config.clientToQueryMongo();

    try {
      var result = await client
          .query(QueryOptions(documentNode: gql(query.getAllRoom())));
      ListRoom v = ListRoom.fromJson(result.data);
      if(mounted){
        setState(() {
        room = v.listRoom;
      });
      }

      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() async {
    // monitor network fetch
     int newPage= page+1;
        GraphQLClient client = config.clientToQueryMongo();
        var result = await client
            .query(QueryOptions(
               variables: {"page": newPage, "limit": limit},
              documentNode: gql(query.getAllRoom())));
        List<Room> v = ListRoom.fromJson(result.data).listRoom;
        Provider.of<FetchMoreValue>(context,listen: false).setMoreValue(v);
    if (mounted)
      setState(() {
       
        /*SharedPreferences refs = await SharedPreferences.getInstance();
        List<String> res = refs.getStringList("userToken");

        GraphQLClient client = config.clientToQueryMongo();
        var result = await client
            .query(QueryOptions(documentNode: gql(query.getAllRoom())));
        var v = ListRoom.fromJson(result.data);
        print(v);*/
       
      });
    _refreshController.loadComplete();
  }

  
  /* FetchMoreOptions fetchmore() {
       return FetchMoreOptions(
         variables: {"page": page + 1, "limit": limit},
        updateQuery: (previousResultData, fetchMoreResultData) {
                            print(fetchMoreResultData);
                            return "";
                          });
   }*/

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final value =  Provider.of<FetchMoreValue>(context);
    for (var item in room) {
      print(" room length : ${item.roomName}");
    }
    super.build(context);
    return ChangeNotifierProvider<FetchMoreValue>(
      lazy: true,
      create: (context) => FetchMoreValue(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.PRIMARY_COLOR,
            child: Icon(Icons.add),
            onPressed: () {
              room.add(Room(createAt: "2020-02-14T15:18:08.661Z",
              gameInfo: {"gameName":"asd","gameID":'"Asd'},hostID: "47",id: "Asdadasdasd54",isPrivate: false,maxOfMember: 4,memberID: ["47","48"],roomName: "Jkkkkkk"));
              //Navigator.push(context,MaterialPageRoute(maintainState: true,fullscreenDialog: true,builder: (context) => CreateRoom()));
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: GraphQLProvider(
          client: config.client,
          child: CacheProvider(
            child: Container(
              padding: EdgeInsets.all(10),
                height: screenSize.height,
                child: Query(
                  options: QueryOptions(

                      variables: {"page": page, "limit": limit},
                      documentNode: gql(query.getAllRoom())),
                  builder: (QueryResult result,{VoidCallback refetch, FetchMore fetchMore}) {
                   
                    if (result.loading) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: SpinKitSquareCircle(
                          color: Colors.white,
                          size: 20,
                        ),
                      );
                    } else {
                      ListRoom v = ListRoom.fromJson(result.data);
                      room = v.listRoom;
                      return SmartRefresher(
                          enablePullUp: true,
                          footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {
                              body = Text("pull up load");
                            } else if (mode == LoadStatus.loading) {
                              body = SpinKitCubeGrid(
                                color: Colors.white,
                                size: 15,
                              );
                            } else if (mode == LoadStatus.failed) {
                              body = Text("Load Failed!Click retry!");
                            } else if (mode == LoadStatus.canLoading) {
                              body = Text("Release to load more");
                            } else {
                              body = Text("No more Data");
                            }
                            return Container(
                              height: 55.0,
                              child: Center(child: body),
                            );
                          }),
                          onOffsetChange: (bool isChange , offset) {
                            //fetchMore(fetchmore());
                            if(isChange==true){
                              //fetchMore(fetchmore());
                               /* WidgetsBinding.instance.addPostFrameCallback((_){
                                  room.addAll(value.getMoreValue);
                                });*/
                             _refreshController.loadComplete();
                            }
                          },
                          onLoading: () => _onLoading(),
                          onRefresh: () => _onRefresh(),
                          controller: _refreshController,
                          child: ListView.separated(
                              separatorBuilder: (context, index) => Column(
                                    children: <Widget>[
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                              itemCount: room.length,
                              itemBuilder: (context, index) {
                               
                                var v = DateTime.now().difference(
                                    DateTime.tryParse(room[index].createAt)
                                        .toLocal());
                                
                                return Material(
                                  color: Colors.transparent,
                                  type: MaterialType.button,
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConstraint
                                                  .container_border_radius)),
                                      width: screenSize.width,
                                      height: 120,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(15),
                                                    onTap: () {},
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        height: 150,
                                                        width: 60,
                                                        fadeInCurve:
                                                            Curves.easeIn,
                                                        fadeInDuration:
                                                            Duration(seconds: 2),
                                                        imageUrl:
                                                            "https://via.placeholder.com/150",
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 80,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            room[index]
                                                                    .roomName ??
                                                                "Room name",
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                  "${v.inMinutes} minuties ago"))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text("post on "),
                                                          InkWell(
                                                              onTap: () {},
                                                              child: Text(room[
                                                                              index]
                                                                          .gameInfo !=
                                                                      null
                                                                  ? "${room[index].gameInfo["gameName"]}"
                                                                  : "null")),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                      height: 30,
                                                      alignment: Alignment.center,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .PRIMARY_COLOR,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15)),
                                                      child: Text(
                                                          "${room[index].memberID.length}/ ${room[index].maxOfMember}")),
                                                )
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 50,
                                            child: Container(
                                                height: 50,
                                                width: screenSize.width - 40,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.bottomRight,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Material(
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              type: MaterialType
                                                                  .circle,
                                                              color: Colors
                                                                  .transparent,
                                                              child: IconButton(
                                                                  icon: Icon(Icons
                                                                      .message),
                                                                  onPressed:
                                                                      () {}),
                                                            ),
                                                            Material(
                                                              type: MaterialType
                                                                  .circle,
                                                              color: Colors
                                                                  .transparent,
                                                              clipBehavior:
                                                                  Clip.antiAlias,
                                                              child: IconButton(
                                                                  icon: Icon(Icons
                                                                      .add_box),
                                                                  onPressed: () {
                                                                    print(
                                                                        "ASD  ");
                                                                  }),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //user already join room, base on number of people join, generate properly
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        
                      );
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
