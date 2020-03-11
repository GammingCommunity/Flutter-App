import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/view/dashboard/categories_detail/add_room.dart';
import 'package:gamming_community/view/room/create_room.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_player/video_player.dart';

GlobalKey _globalKey = GlobalKey();

class CategoriesDetail extends StatefulWidget {
  final String itemTag;
  final Game gameDetail;
  CategoriesDetail({this.itemTag, this.gameDetail});
  @override
  _CategoriesDetailState createState() => _CategoriesDetailState();
}

class _CategoriesDetailState extends State<CategoriesDetail>
    with TickerProviderStateMixin {
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
  bool hidePlayButton = false;
  Config config = Config();
  GraphQLQuery query = GraphQLQuery();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    _controller = VideoPlayerController.network(widget.gameDetail.trailerUrl);
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
      showControls: showControl,
      overlay: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              type: MaterialType.circle,
              child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Visibility(
              visible: hidePlayButton,
              child: IconButton(
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () {
                    setState(() {
                      _chewieController.play();
                      hidePlayButton=!hidePlayButton;
                    });
                  }),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(icon: Icon(Icons.volume_up), onPressed: () {}),
          )
        ],
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.white,
        handleColor: Colors.indigo,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.blueGrey,
      ),
    );
    //print("${_scrollController.offset}");
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 243) {
          setState(() {
            titleExpanded = !titleExpanded;
            displaytoAppbar = !displaytoAppbar;
            hideCreateButton = !hideCreateButton;
            // _chewieController.pause();
          });
        } else if (_scrollController.offset < 200) {
          setState(() {
            titleExpanded = false;
            displaytoAppbar = true;
            hideCreateButton = true;
            //_chewieController.play();
            //displaytoAppbar=!displaytoAppbar;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients && _scrollController.offset < (190);
  }

  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final game = widget.gameDetail;
    return Scaffold(
      body: Hero(
          tag: widget.itemTag,
          child: CustomScrollView(
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
                  background: Container(
                    height: 260,
                    width: screenSize.width,
                    child: Chewie(
                      controller: _chewieController,
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
                          Material(
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAlias,
                            type: MaterialType.circle,
                            child: IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.chevron_left),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: game.logo,
                            placeholder: (context, url) => SpinKitCubeGrid(
                              color: Colors.white,
                              size: 10,
                            ),
                            imageBuilder: (context, imageProvider) => Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider)),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error_outline,
                              size: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(game.name),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateRoom()));
                              },
                              child: Text("Create room"),
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
                    width: screenSize.width,
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: tabController,
                        tabs: [
                          Tab(
                            text: 'Summary',
                          ),
                          Tab(
                            text: 'Room',
                          ),
                          Tab(
                            text: 'Community',
                          )
                        ])),
                GraphQLProvider(
                  client: config.client,
                  child: CacheProvider(
                    child: Container(
                      height: screenSize.height,
                      padding: EdgeInsets.all(10),
                      child: TabBarView(
                        controller: tabController,
                        children: <Widget>[
                          // Tab 1: Summary info
                          Column(
                            children: <Widget>[
                              Visibility(
                                maintainState: true,
                                maintainSize: true,
                                maintainAnimation: true,
                                visible: displaytoAppbar,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: game.logo,
                                      placeholder: (context, url) => Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey)),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider)),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error_outline,
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 20.0, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            game.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          //TODO: sample here, add soon
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Wrap(
                                              spacing: 10,
                                              children: <Widget>[
                                                for (var item in [1, 2, 3])
                                                  Chip(label: Text("No Tag"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    game.summary,
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.fade,
                                    maxLines: descTextShowFlag ? 20 : 8,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            descTextShowFlag =
                                                !descTextShowFlag;
                                          });
                                        },
                                        child: descTextShowFlag
                                            ? Text("Show less")
                                            : Text("Show more"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // this for screenshot slider
                              CarouselSlider.builder(
                                itemCount: game.images.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: screenSize.width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CachedNetworkImage(
                                      width: screenSize.width,
                                      imageUrl: game.images[index],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider)),
                                      ),
                                      placeholder: (context, url) => Container(
                                        width: screenSize.width,
                                        color: Colors.grey,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                                height: 200,
                                realPage: game.images.length,
                              )
                            ],
                          ),
                          // tab 2 : list room base on GameID
                          FutureBuilder(
                            future: Future.delayed(Duration(seconds: 2)),
                            builder: (context, snapshot) => Query(
                              options: QueryOptions(
                                  variables: {"page": 1, "limit": 5},
                                  documentNode: gql(query.getAllRoom())),
                              builder: (result, {fetchMore, refetch}) {
                                if (result.loading) {
                                  return SpinKitFadingCircle(
                                      color: Colors.white, size: 20);
                                } else {
                                  print(result.data);
                                  return ListView.builder(
                                    itemCount: result.data['getAllRoom'].length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 40,
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text("Join our community"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]))
            ],
          )),
    );
  }
}
