import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/CountRoom.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/specify_room_game/room_by_game.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

class SummaryRoom extends StatefulWidget {
  @override
  _SummaryRoomState createState() => _SummaryRoomState();
}

class _SummaryRoomState extends State<SummaryRoom>
    with AutomaticKeepAliveClientMixin {
  Config config = Config();
  GraphQLQuery query = GraphQLQuery();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(10),
        height: screenSize.height,
        width: screenSize.width,
        child: GraphQLProvider(
          client: config.client,
          child: CacheProvider(
              child: Query(
            options: QueryOptions(
                documentNode: gql(query.countRoomOnEachGame('ASC'))),
            builder: (result, {fetchMore, refetch}) {
              if (result.loading) {
                return Align(
                    alignment: Alignment.center,
                    child: AppConstraint.spinKitCubeGrid);
              }
              if (result.hasException ||
                  result.data['countRoomOnEachGame'] as List<dynamic> == []) {
                return Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
                        Text("Error during fetch, try again")
                      ],
                    ));
              } else {
                var listRoom =
                    ListNumberOfRoom.json(result.data['countRoomOnEachGame'])
                        .listRoom;
                return Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20,
                    ),
                    itemCount: listRoom.length,
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        elevation: 4,
                        clipBehavior: Clip.antiAlias,
                        type: MaterialType.button,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=>RoomByGame(gameID:listRoom[index].id)));
                          },
                          child: Container(
                            width: screenSize.width,
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: listRoom[index].background,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            enabled: true,
                                            child: Container(),
                                            baseColor: Colors.grey[300],
                                            highlightColor: Colors.grey[100]),
                                  ),
                                ),
                                Positioned(
                                    left: 30,
                                    top: 40,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${listRoom[index].gameName}",
                                          style: TextStyle(
                                            shadows: [
                                              Shadow(blurRadius: 6,color: Colors.black,offset: Offset(2, 3))
                                            ],
                                              fontSize:
                                                  AppConstraint.roomTitleSize),
                                        ),
                                        Text(
                                          "${listRoom[index].count} room",
                                          style: TextStyle(
                                              fontSize:
                                                  AppConstraint.roomTitleSize),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
