import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RoomByGame extends StatefulWidget {
  final String gameID, token;
  RoomByGame({this.gameID, this.token});
  @override
  _RoomByGameState createState() => _RoomByGameState();
}

class _RoomByGameState extends State<RoomByGame> {
  GraphQLQuery query = GraphQLQuery();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: GraphQLProvider(
                client: customClient(widget.token),
                child: CacheProvider(
                    child: Query(
                        options:
                            QueryOptions(documentNode: gql(query.getListRoomByID(widget.gameID))),
                        builder: (result, {fetchMore, refetch}) {
                          if (result.loading) {
                            return Align(
                                alignment: Alignment.center, child: AppConstraint.spinKitCubeGrid(context));
                          }
                          if (result.hasException) {
                            return AppConstraint.emptyIcon;
                          } else {
                            var room = Rooms.fromJson(result.data['getRoomByGame']).rooms;

                            return ListView.separated(
                                separatorBuilder: (context, index) => Column(
                                      children: <Widget>[
                                        Divider(thickness: 1),
                                        SizedBox(height: 10)
                                      ],
                                    ),
                                itemCount: room.length,
                                itemBuilder: (context, index) {
                                  var v = DateTime.now().difference(
                                      DateTime.tryParse(room[index].createAt).toLocal());

                                  return InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppConstraint.container_border_radius)),
                                      width: screenSize.width,
                                      height: 120,
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned(
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(15),
                                                    onTap: () {},
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        height: 150,
                                                        width: 80,
                                                        fadeInCurve: Curves.easeIn,
                                                        fadeInDuration: Duration(seconds: 2),
                                                        imageUrl: "https://via.placeholder.com/150",
                                                        placeholder: (context, url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context, url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 100,
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
                                                            room[index].roomName ?? "Room name",
                                                            style: TextStyle(fontSize: 18),
                                                          ),
                                                          Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                  "${v.inMinutes} minuties ago")),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              DisplayMember(
                                                                borderRadius: 1000,
                                                                size: 30,
                                                                  ids: room[index].memberID,
                                                                )
                                                              /*for (var user in room[index].memberID)
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(1000),
                                                                  child: CachedNetworkImage(
                                                                      height: 40,
                                                                      width: 40,
                                                                      placeholder: (context, url) =>
                                                                          Container(
                                                                            color: Colors.grey[400],
                                                                          ),
                                                                      imageUrl: ),
                                                                ),*/
                                                                
                                                            ],
                                                          )
                                                        ],
                                                      ),
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
                                                          color: AppColors.PRIMARY_COLOR,
                                                          borderRadius: BorderRadius.circular(15)),
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
                                                width: screenSize.width - 20,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned(
                                                      bottom: 0,
                                                      right: 0,
                                                      child: Align(
                                                        alignment: Alignment.bottomRight,
                                                        child: Row(
                                                          children: <Widget>[
                                                            //Menu chat, join room
                                                            Material(
                                                              clipBehavior: Clip.antiAlias,
                                                              type: MaterialType.circle,
                                                              color: Colors.transparent,
                                                              child: IconButton(
                                                                  icon: Icon(Icons.message),
                                                                  onPressed: () {}),
                                                            ),
                                                            Material(
                                                              type: MaterialType.circle,
                                                              color: Colors.transparent,
                                                              clipBehavior: Clip.antiAlias,
                                                              child: IconButton(
                                                                  icon: Icon(Icons.add_box),
                                                                  onPressed: () {
                                                                    print("ASD  ");
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
                                  );
                                });
                          }
                        })))));
  }
}
