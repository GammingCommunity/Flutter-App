import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customImage.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/view/game_detail/game_detail_tab/rateAndComment.dart';
import 'package:gamming_community/view/game_detail/game_detail_tab/summaryTab.dart';
import 'package:gamming_community/view/game_detail/provider/game_detail_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:video_player/video_player.dart';

class GameDetail extends StatefulWidget {
  final String gameID;
  final String itemTag;
  GameDetail({this.gameID = "", this.itemTag});
  @override
  _GameDetailState createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> with TickerProviderStateMixin {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  ScrollController _scrollController;
  TabController tabController;
  bool isShowControll = false;
  bool hideButton = true;
  bool titleExpanded = false;
  bool displaytoAppbar = true;
  bool showControl = false;
  bool hideCreateButton = false;
  // hide more text
  bool descTextShowFlag = false;
  bool playButton = true;
  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
    _controller = VideoPlayerController.network(
        "https://droncoma.sirv.com/video/Tom%20Clancy's%20The%20Division%20-%20Launch%20Trailer%20-%20Ubisoft%20%5BNA%5D.mp4");
    _chewieController = ChewieController(
        autoInitialize: true,
        videoPlayerController: _controller,
        allowMuting: true,
        aspectRatio: 4 / 2,
        systemOverlaysAfterFullScreen: [SystemUiOverlay.top],
        looping: false,
        showControlsOnInitialize: false,
        errorBuilder: (context, errorMessage) {
          return Container(color: Colors.blueGrey);
        },
        autoPlay: false,
        overlay: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    playButton = !playButton;
                  });
                },
                child: Visibility(
                  visible: playButton,
                  child: IconButton(
                      icon: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          if (!playButton) {
                            print(playButton);
                            _chewieController.pause();
                          } else {
                            print(playButton);
                            _chewieController.play();
                            playButton = !playButton;
                          }
                        });
                      }),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: CircleIcon(icon: FeatherIcons.arrowLeft, onTap: () => Get.back())),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {
                      _chewieController.setVolume(0);
                    }),
              ),
            )
          ],
        ),
        materialProgressColors: AppConstraint.chewieProgressColors);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 243) {
          if (titleExpanded == true && displaytoAppbar == false && hideCreateButton == false) {
            return;
          } else
            setState(() {
              titleExpanded = !titleExpanded;
              displaytoAppbar = !displaytoAppbar;
              hideCreateButton = !hideCreateButton;
              //_chewieController.pause();
            });
        } else if (_scrollController.offset < 200) {
          if (titleExpanded == true && displaytoAppbar == false && hideCreateButton == true) {
            return;
          } else
            setState(() {
              titleExpanded = false;
              displaytoAppbar = true;
              hideCreateButton = true;
              // _chewieController.play();
              //displaytoAppbar=!displaytoAppbar;
            });
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WhenRebuilderOr<GameDetailProvider>(
          initState: (context, model) => model.setState((s) => s.initloadGameInfo(widget.gameID)),
          observe: () => RM.get<GameDetailProvider>(),
          onWaiting: () => Center(child: AppConstraint.loadingIndicator(context)),
          builder: (context, model) {
            var game = model.state.game;
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 220,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: GestureDetector(
                      onTap: () async {
                        _chewieController.play();
                      },
                      child: Container(
                        height: 260,
                        width: Get.width,
                        child: Chewie(
                          controller: _chewieController,
                        ),
                      ),
                    ),
                    titlePadding: EdgeInsets.all(0),
                    title: Visibility(
                      visible: titleExpanded,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleIcon(
                                icon: FeatherIcons.arrowLeft,
                                onTap: () {
                                  Get.back();
                                }),
                            SizedBox(width: 10),
                            CustomImage(
                                url: game.logo,
                                imageBorderRadius: 15,
                                imageHeight: 50,
                                imageWidth: 50),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  game.name,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                onPressed: () {},
                                child: Text("Create rooms"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                      width: Get.width,
                      child: TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          controller: tabController,
                          isScrollable: false,
                          tabs: [
                            Tab(
                              text: 'Summary',
                            ),
                            Tab(
                              text: 'Rate and Comment',
                            )
                          ])),
                  Container(
                    height: Get.height,
                    padding: EdgeInsets.all(10),
                    child: TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        // Tab 1: Summary info section
                        SummaryTab(),
                        // Tab 2 : Rate and Comment section
                        RateAndComment()
                      ],
                    ),
                  ),
                ]))
              ],
            );
          }),
    );
  }
}
