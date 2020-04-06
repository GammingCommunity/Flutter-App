import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/class/Room.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/messages/group_messages/group_message.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RoomDetailV2 extends StatefulWidget {
  final String itemTag;
  final Room room;
  RoomDetailV2({this.room, this.itemTag});
  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetailV2> with TickerProviderStateMixin {
  GraphQLQuery query = GraphQLQuery();
  ScrollController scrollController;
  AnimationController animationController;
  Animation animation;
  TabController tabController;
  double silverAppBarHeight = 200;
  bool hideTitle = true;
  bool hideGroupMember = true;
  bool hideDetail = true;
  double currentOffset = 0.0;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    /*scrollController = ScrollController()
      ..addListener(() {
        print(scrollController.offset);
        if (scrollController.offset >= AppBar().preferredSize.height) {
          print(">=60 true");
          if (hideTitle == false && hideGroupMember == false && hideDetail == false) {
            return;
          } else
            setState(() {
              // change
              animationController.forward();
              hideTitle = !hideTitle;
              hideGroupMember = !hideGroupMember;
              hideDetail = !hideDetail;
              print("$hideTitle, $hideGroupMember, $hideDetail at >=60");
            });
        } else if (scrollController.offset <= silverAppBarHeight) {
          print("<=136 true");
          if (hideTitle == true && hideGroupMember == true && hideDetail == true) {
            return;
          } else
            setState(() {
              //default
              hideTitle = true;
              hideGroupMember = true;
              hideDetail = true;
            });
          return;
        }
      });*/

    super.initState();
  }

  @override
  void dispose() {
    //scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var room = widget.room;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    type: MaterialType.circle,
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  Text(
                    room.roomName,
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Flexible(
                      child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    reverse: true,
                    itemCount: room.memberID.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => CachedNetworkImage(
                       
                        imageBuilder: (context, imageProvider) => Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                            ),
                        imageUrl: room.memberID[index].profileUrl as String),
                  ))
                ],
              ),
              preferredSize: Size.fromHeight(40)),
          body: Hero(
              tag: widget.itemTag,
              child: Container(
                  height: screenSize.height,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TabBarView(controller: tabController, children: <Widget>[
                    // tab 1 : message group
                    GroupMessage(
                      silverBarHeight: silverAppBarHeight,
                      roomID: widget.room.id,
                      member: widget.room.memberID,
                      currentID: "43",
                    ),

                    //tab 2 :show file file
                    Container()

                    // share a screenShot or somthing like that
                  ])))),
    );

    // CustomScrollView(controller: scrollController, slivers: <Widget>[

    //   SliverList(
    //       delegate: SliverChildListDelegate([
    //     TabBar(indicatorSize: TabBarIndicatorSize.label, controller: tabController, tabs: [
    //       Tab(
    //         icon: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[Icon(Icons.message), SizedBox(width: 10), Text("Chat")],
    //         ),
    //       ),
    //       Tab(
    //           icon: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[Icon(Icons.file_upload), SizedBox(width: 10), Text("Files")],
    //       ))
    //     ]),

    //   ]))
    // ])));
  }
}

class GameLogoWidget extends StatefulWidget {
  final String gameName;
  GameLogoWidget({this.gameName});
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameLogoWidget> {
  var query = GraphQLQuery();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: (Future(() async {
        var result = await MainRepo.queryGraphQL("", query.searchGame(widget.gameName));
        return Game.fromJson(result.data).logo;
      })),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 60,
              width: 60,
              decoration:
                  BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15)));
        } else {
          return CachedNetworkImage(
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(image: imageProvider)),
                  ),
              imageUrl: snapshot.data);
        }
      },
    );
  }
}
