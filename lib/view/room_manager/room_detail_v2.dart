import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/view/messages/group_messages/group_message.dart';
import 'package:gamming_community/view/messages/group_messages/group_message_view.dart';
import 'package:gamming_community/view/messages/models/group_chat_provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomDetailV2 extends StatefulWidget {
  final String itemTag;
  final GroupChat room;
  RoomDetailV2({this.room, this.itemTag});
  @override
  _RoomDetailState createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetailV2> with TickerProviderStateMixin {
  GraphQLQuery query = GraphQLQuery();
  ScrollController scrollController;
  AnimationController animationController;
  GroupChatProvider groupChatProvider;
  Animation animation;
  TabController tabController;
  double silverAppBarHeight = 200;
  bool hideTitle = true;
  bool hideGroupMember = true;
  bool hideDetail = true;
  double currentOffset = 0.0;
  String userID = "";
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    getUserID().then((value) {
      setState(() {
        this.userID = value;
      });
    });
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

  Future getUserID() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    return refs.getString("userID");
  }

  @override
  void dispose() {
    //scrollController.dispose();
    animationController.dispose();
    groupChatProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var room = widget.room;
    groupChatProvider = Injector.get(context: context);
    return Hero(
      tag: widget.itemTag,
      child: DefaultTabController(
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
                            onPressed: () async {
                              groupChatProvider.clearAndUpdate();

                              Navigator.of(context).pop();
                            }),
                      ),
                      TextResponsive(
                        room.roomName,
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Material(
                        clipBehavior: Clip.antiAlias,
                        type: MaterialType.circle,
                        color: Colors.transparent,
                        child: IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {
                              // call audio
                            }),
                      ),
                      CircleIcon(
                        icon: Icons.info,
                        iconSize: 30,
                        onTap: () {
                          // show member
                        },
                      )
                      /*Container(
                      height: 40,
                      width: 100,
                        child: ListView.builder(
                      
                      reverse: true,
                      itemCount: room.memberID.length,
                      scrollDirection: Axis.horizontal,
                    
                      itemBuilder: (context, index) => CachedNetworkImage(
                           
                            imageBuilder: (context, imageProvider) => Container(
                                  height: 30,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                ),
                            imageUrl: room.memberID[index].profileUrl as String),
                      ),
                    )*/
                    ],
                  ),
                  preferredSize: Size.fromHeight(40)),
              body: Container(
                  height: screenSize.height,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TabBarView(controller: tabController, children: <Widget>[
                    // tab 1 : message group
                    GroupMessageWidget(
                      silverBarHeight: silverAppBarHeight,
                      roomID: widget.room.id,
                      member: widget.room.memberID,
                      currentID: userID,
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
/*
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
}*/
