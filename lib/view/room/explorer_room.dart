import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/CountRoom.dart';
import 'package:gamming_community/provider/search_bar.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/specify_room_game/room_by_game.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gamming_community/utils/skeleton_items.dart';
import 'package:video_player/video_player.dart';

class Explorer extends StatefulWidget {
  @override
  _SummaryRoomState createState() => _SummaryRoomState();
}

class _SummaryRoomState extends State<Explorer> with AutomaticKeepAliveClientMixin {
  Config config = Config();
  GraphQLQuery query = GraphQLQuery();
  ScrollController scrollController;
  double scrollPosition;
  @override
  void initState() {
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
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    //var search = Provider.of<Search>(context);
    return Consumer<Search>(
        builder: (context, value, child) => Container(
            padding: EdgeInsets.all(10),
            height: screenSize.height,
            width: screenSize.width,
            child: GraphQLProvider(
              client: config.client,
              child: CacheProvider(
                  child: Query(
                options: QueryOptions(documentNode: gql(query.countRoomOnEachGame('ASC'))),
                builder: (result, {fetchMore, refetch}) {
                  if (result.loading) {
                    // return Align(
                    //     alignment: Alignment.center,
                    //     child: AppConstraint.spinKitCubeGrid);
                    return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                      ),
                      itemCount: 10,
                      // Important code
                      itemBuilder: (context, index) => SizedBox(
                        height: 100,
                        width: screenSize.width,
                        child: Shimmer.fromColors(
                            baseColor: Colors.grey[400],
                            highlightColor: Colors.white,
                            child: OnDemandItem()),
                      ),
                    );
                  }
                  if (result.hasException ||
                      result.data['countRoomOnEachGame'] as List<dynamic> == []) {
                        print(result.exception);
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
                        ListNumberOfRoom.json(result.data['countRoomOnEachGame']).listRoom;
                    return Container(
                      width: screenSize.width,
                      height: screenSize.height,
                      child: NotificationListener(
                        onNotification: (notification) {
                          if (notification is ScrollUpdateNotification) {
                            value.setCurrentScrollOffset(scrollPosition);
                          }
                          /*print("current scroll position" + scrollPosition.toString());
                          print(search.currentOffset);*/

                          if (scrollPosition == 0.0 && scrollPosition < 100) {
                            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                              value.setHideSearchBar(true);
                            });
                          }
                          if (value.currentOffset > 100) {
                            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                              value.setHideSearchBar(false);
                            });
                          }
                        },
                        child: ListView.separated(
                          controller: scrollController,
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
                                          builder: (context) =>
                                              RoomByGame(gameID: listRoom[index].id)));
                                },
                                child: Container(
                                  width: screenSize.width,
                                  child: Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: CachedNetworkImage(
                                          imageUrl: listRoom[index].background,
                                          placeholder: (context, url) => Shimmer.fromColors(
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${listRoom[index].gameName}",
                                                style: TextStyle(shadows: [
                                                  Shadow(
                                                      blurRadius: 6,
                                                      color: Colors.black,
                                                      offset: Offset(2, 3))
                                                ], fontSize: AppConstraint.roomTitleSize),
                                              ),
                                              Text(
                                                "${listRoom[index].count} room",
                                                style: TextStyle(
                                                    fontSize: AppConstraint.roomTitleSize),
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
                      ),
                    );
                  }
                },
              )),
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
