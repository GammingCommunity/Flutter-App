import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/repository/main_repo.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/messages/group_messages/group_message.dart';
import 'package:gamming_community/view/group_dashboard/group_page/group_message.dart';

class RoomDetail extends StatefulWidget {
  final String itemTag;
  final GroupChat room;
  RoomDetail({this.room, this.itemTag});
  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> with TickerProviderStateMixin {
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
    scrollController = ScrollController()
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
      });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var room = widget.room;

    return Scaffold(
        body: Hero(
            tag: widget.itemTag,
            child: CustomScrollView(controller: scrollController, slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.blue,
                pinned: true,
                floating: false,
                snap: false,
                expandedHeight: silverAppBarHeight,
                title: Visibility(
                    visible: !hideTitle,
                    child: FadeTransition(opacity: animation, child: Text(widget.room.roomName))),
                actions: <Widget>[
                  Visibility(
                    visible: !hideGroupMember,
                    child: Container(
                      height: 40,
                      width: 200,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(width: 5),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.room.memberID.length,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10000)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10000),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) => Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10000),
                                          image: DecorationImage(image: imageProvider)),
                                    ),
                                imageUrl: room.memberID[index].profileUrl as String),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
                elevation: 0,
                automaticallyImplyLeading: true,
                titleSpacing: 0,
                flexibleSpace: FlexibleSpaceBar(
                  
                  background: Container(color: AppColors.BACKGROUND_COLOR),
                  collapseMode: CollapseMode.parallax,
                  title: Visibility(
                    replacement: Container(),

                    visible: hideDetail,
                    child: Container(
                      height: 100,
                      color: Colors.amber,
                      width: screenSize.width,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  // member avatar here

                                  Container(
                                    height: 50,
                                    width: screenSize.width / 2,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) => SizedBox(width: 5),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: room.memberID.length,
                                      itemBuilder: (context, index) => CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageBuilder: (context, imageProvider) => Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    image: DecorationImage(image: imageProvider)),
                                              ),
                                          imageUrl: room.memberID[index].profileUrl as String),
                                    ),
                                  ),

                                  //game logo here

                                  // GameLogoWidget(gameName: room.gameInfo['gameName']),
                                ],
                              ),
                            ),
                          ),
                          Positioned(left: 10, child: Text(widget.room.roomName)),
                        ],
                      ),
                    ),
                  ),
                  titlePadding: EdgeInsets.all(0),
                ),
              ),

              SliverList(
                  delegate: SliverChildListDelegate([
                TabBar(indicatorSize: TabBarIndicatorSize.label, controller: tabController, tabs: [
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.message), SizedBox(width: 10), Text("Chat")],
                    ),
                  ),
                  Tab(
                      icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.file_upload), SizedBox(width: 10), Text("Files")],
                  ))
                ]),
                Container(
                    height: screenSize.height - silverAppBarHeight / 2 - 70,
                    padding: EdgeInsets.all(10),
                    child: TabBarView(controller: tabController, children: <Widget>[
                      // tab 1 : message group
                      GroupMessageWidget(
                        roomID: widget.room.id,
                        member: widget.room.memberID,
                        currentID: "43",
                      ),

                      //tab 2 :show file file
                      Container()

                      // share a screenShot or somthing like that
                    ]))
              ]))
            ])));
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
        var result = await MainRepo.queryGraphQL("", query.searchGame(widget.gameName,""));
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
