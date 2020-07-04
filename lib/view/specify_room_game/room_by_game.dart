import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/controller/roomByGameController.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/profile/profileController.dart';
import 'package:gamming_community/view/specify_room_game/provider/roomByGameProvider.dart';
import 'package:gamming_community/view/specify_room_game/roomItem.dart';
import 'package:gamming_community/view/specify_room_game/sortButton.dart';
import 'package:gamming_community/view/specify_room_game/sortChip.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RoomByGame extends StatefulWidget {
  final String gameID, token;
  final String gameName;
  RoomByGame({this.gameID, this.gameName, this.token});
  @override
  _RoomByGameState createState() => _RoomByGameState();
}

class _RoomByGameState extends State<RoomByGame> with TickerProviderStateMixin {
  var fRefreshController = FRefreshController();
  GraphQLQuery query = GraphQLQuery();
  ScrollController scrollController;
  RoomByGameProvider roomByGameProvider;
  AnimationController controller;
  AnimationController _animationController;
  Animation _curve;
  Animation<RelativeRect> _animation;
  bool isPress = false;
  @override
  void initState() {
    /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await roomsProvider.initLoad(widget.gameID, "none");
    });*/
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _curve = CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn);

    _animation = RelativeRectTween(
            begin: RelativeRect.fromLTRB(0, 0, 0, 0), end: RelativeRect.fromLTRB(0, 50, 0, 0))
        .animate(_curve);

    scrollController = ScrollController()
      ..addListener(() {
        loadMore();
      });
    super.initState();
  }

  void loadMore() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      print("here");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    roomByGameProvider = Injector.get();
    return Hero(
        tag: widget.gameID,
        child: Scaffold(
            appBar: CustomAppBar(
                padding: EdgeInsets.only(right: 10),
                child: [
                  Text(widget.gameName, style: TextStyle(fontSize: 20)),
                  Spacer(),
                  SortButton(
                    onSelected: (value) {
                      value ? _animationController.forward() : _animationController.reverse();
                    },
                  ),
                ],
                height: 40,
                onNavigateOut: () {
                  Get.back();
                  roomByGameProvider.clear();
                },
                backIcon: FeatherIcons.arrowLeft),
            body: WhenRebuilder<RoomByGameProvider>(
                initState: (context, roomByGame) =>
                    roomByGame.setState((s) => s.initLoad(widget.gameID, "none")),
                onIdle: null,
                onError: (error) => buildError(error),
                observe: () => RM.get<RoomByGameProvider>(),
                onWaiting: () => Center(child: AppConstraint.loadingIndicator(context)),
                onData: (data) => Container(
                      height: Get.height,
                      width: Get.width,
                      child: Stack(
                        children: <Widget>[
                          Container(
                              height: 50,
                              width: Get.width,
                              color: Colors.black,
                              child: SortChip(onSelected: (value) async {
                                await data.sortBy(value);
                              })),
                          PositionedTransition(
                            rect: _animation,
                            child: Container(
                                height: Get.height,
                                width: Get.width,
                                padding: EdgeInsetsResponsive.only(top: 10),
                                color: ProfileController.to.darkTheme ? Colors.black : Colors.white,
                                child: data.groupGame.isEmpty
                                    ? Center(
                                        child: Text("No room found !"),
                                      )
                                    : FRefresh(
                                        controller: fRefreshController,
                                        headerHeight: 70,
                                        headerBuilder: (setter, constraints) {
                                          //await _privateChatProvider.refresh();
                                          return buildHeader();
                                        },
                                        footerHeight: 60.0,
                                        footerBuilder: (setter) => buildFooter(),
                                        onRefresh: () async {
                                          print("on refresh");
                                          //await privateChat.state.initPrivateConservation();
                                          fRefreshController.finishRefresh();
                                        },
                                        onLoad: () async {
                                          print("onLoad");
                                          await roomByGameProvider.loadMore();
                                          fRefreshController.finishLoad();
                                          /* Timer(Duration(milliseconds: 3000), () {
                                            e.fRefreshController.finishLoad();
                                            print(
                                                'controller4.position = ${e.fRefreshController.position}, controller4.scrollMetrics = ${e.fRefreshController.scrollMetrics}');
                                          });*/
                                        },
                                        child: Container(
                                          height: Get.height,
                                          width: Get.width,
                                          child: ListView.separated(
                                              physics: NeverScrollableScrollPhysics(),
                                              separatorBuilder: (context, index) =>
                                                  Divider(thickness: 1),
                                              itemCount: data.groupGame.length,
                                              itemBuilder: (context, index) {
                                                var groupChat = data.groupGame;
                                                return RoomItem(room: groupChat[index]);
                                              }),
                                        ))),
                          ),
                        ],
                      ),
                    ))));
  }
}

Widget buildError(String errorCode) {
  return Center(
    child: Column(
      children: [Text("Has error"), Text(errorCode)],
    ),
  );
}

Widget buildHeader() {
  return Container(
    height: 50,
    alignment: Alignment.bottomCenter,
    child: SizedBox(
      width: 15,
      height: 15,
      child: CircularProgressIndicator(
        backgroundColor: Color(0xfff1f3f6),
        valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
        strokeWidth: 2.0,
      ),
    ),
  );
}

Widget buildFooter() {
  return Container(
      height: 40,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(
              backgroundColor: Color(0xfff1f3f6),
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff6c909b)),
              strokeWidth: 2.0,
            ),
          ),
          SizedBox(width: 9.0),
          Text(
            "Load more",
            style: TextStyle(color: Color(0xff6c909b)),
          ),
        ],
      ));
}
