import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/customImage.dart';
import 'package:gamming_community/customWidget/iconWithTitle.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/view/friend_profile/provider/friend_profile_provider.dart';
import 'package:gamming_community/view/friend_profile/view/about_tab.dart';
import 'package:gamming_community/view/friend_profile/view/like_tab.dart';
import 'package:gamming_community/view/friend_profile/view/post_tab.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class FriendProfile extends StatefulWidget {
  final int userID;
  FriendProfile({this.userID});

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> with TickerProviderStateMixin {
  TabController tabController;
  ScrollController scrollController = ScrollController();
  double expandedHeight = Get.height / 2.3;
  AnimationController animationController1;
  AnimationController animationController2;
  AnimationController animationController3;
  Animation<double> animation1;
  Animation animation2;
  Animation animation3;
  bool _showAppbar = true;
  bool showName = false;
  bool showFollow = true;
  bool isScrollingDown = false;
  bool _show = true;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    animationController1 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController3 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation1 = Tween(begin: 0.0, end: 1.0).animate(animationController1);
    animation2 = Tween(begin: 0.0, end: 1.0).animate(animationController2);
    animation3 = Tween(begin: 0.0, end: 1.0).animate(animationController3);
    myScroll();
  }

  @override
  void dispose() {
    tabController.removeListener(() {});
    animationController1.dispose();
    animationController2.dispose();
    animationController3.dispose();
    super.dispose();
  }

  void showNameAppBar() {
    setState(() {
      showName = true;
    });
  }

  void hideNameAppBar() {
    setState(() {
      showName = false;
    });
  }

  void myScroll() async {
    animationController1.forward();
    animationController2.forward();
    animationController3.forward();
    scrollController.addListener(() {
      print("scrooll position ${scrollController.offset}");
      if (scrollController.position.userScrollDirection == ScrollDirection.reverse &&
          scrollController.offset >= 130) {
        print("up1 ${scrollController.offset}");
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;

          animationController1.reverse();
          animationController2.reverse();
          animationController3.reverse();
          showNameAppBar();
        }
      }

      if (scrollController.position.userScrollDirection == ScrollDirection.forward &&
          scrollController.offset <= 150) {
        print("down1 ${scrollController.offset}");
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          animationController1.forward();
          animationController2.forward();
          animationController3.forward();
          hideNameAppBar();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isEng = Get.find<SharedPreferences>().getBool("isEng");

    return Scaffold(
      /*  appBar: CustomAppBar(
              child: [],
              height: 50,
              onNavigateOut: () {
                Get.back();
              },
              padding: EdgeInsets.only(right: 10),
              backIcon: FeatherIcons.arrowLeft),*/
      body: WhenRebuilderOr<FriendProfileProvider>(
          initState: (_, friendProfileProvider) =>
              friendProfileProvider.setState((s) => s.getUserInfo(widget.userID)),
          observe: () => RM.get<FriendProfileProvider>(),
          onWaiting: () => Center(
              child:
                  Container(color: Colors.black, child: AppConstraint.loadingIndicator(context))),
          builder: (context, model) => NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: Row(
                        children: [
                          Visibility(visible: showName, child: Text(model.state.userName)),
                          Spacer(),
                          CustomImage(
                            url: model.state.profileUrl,
                            imageBorderRadius: 15,
                            imageHeight: 40,
                            imageWidth: 40,
                          ),
                        ],
                      ),
                      expandedHeight: expandedHeight,
                      backgroundColor: Colors.black,
                      floating: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned(
                              child: Container(
                            height: expandedHeight - 50,
                            width: Get.width,
                            child: CustomImage(
                              url: AppConstraint.default_cover,
                              imageBorderRadius: 0,
                              imageHeight: Get.height - 50,
                              imageWidth: Get.width,
                            ),
                          )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Spacer(),
                                Flexible(
                                  child: FadeTransition(
                                    opacity: animation3,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                model.state.userName,
                                                style: TextStyle(
                                                    fontFamily: "GoogleSans-Bold",
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w800),
                                              ),
                                            ),
                                            Flexible(child: Text("@name"))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                                Flexible(
                                  child: FadeTransition(
                                    opacity: animation2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                            height: 40,
                                            width: Get.width - 100,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)),
                                              onPressed: () {},
                                              child: Text("Follow"),
                                            )),
                                        Spacer(),
                                        CircleIcon(
                                          icon: FeatherIcons.messageCircle,
                                          iconSize: 25,
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: SizedBox(
                                    height: 10,
                                  ),
                                ),
                                Flexible(
                                  child: FadeTransition(
                                    opacity: animation1,
                                    child: Container(
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          buildUserInfo("Followers", 103),
                                          SizedBox(width: 10),
                                          buildUserInfo("Follows", 89),
                                          SizedBox(width: 10),
                                          buildUserInfo("Post", 34)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Container(
                    height: Get.height,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: <Widget>[
                        //Expanded(flex: 1, child: Container()),
                        Expanded(
                            flex: 6,
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: Get.width,
                                    decoration:
                                        BoxDecoration(color: Theme.of(context).primaryColor),
                                    child: TabBar(
                                        controller: tabController,
                                        indicatorColor: Colors.indigo,
                                        indicatorSize: TabBarIndicatorSize.label,
                                        tabs: [Text("Post"), Text("Like"), Text("About")]),
                                  ),
                                  Flexible(
                                    child: TabBarView(
                                      controller: tabController,
                                      
                                      children: [
                                        PostTab(),
                                        LikeTab(),
                                        AboutTab(userID: widget.userID)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        // Setting blablabla....
                      ],
                    )),
              )
          /*    
          CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            title: Row(
              children: [
                Visibility(visible: !_showAppbar, child: Text(model.state.userName)),
                Spacer(),
                CustomImage(
                  url: model.state.profileUrl,
                  imageBorderRadius: 15,
                  imageHeight: 40,
                  imageWidth: 40,
                ),
              ],
            ),
            expandedHeight: Get.height / 2.5,
            backgroundColor: Colors.transparent,
            floating: true,
            flexibleSpace: Stack(
              children: [
                Positioned(
                    child: Container(
                  height: Get.height,
                  width: Get.width,
                  child: CustomImage(
                    url:
                        "https://cdn.image4.io/mattstacey/f_auto/cover/9df0a69a-209d-468f-8171-51c8417eabe0.png",
                    imageBorderRadius: 15,
                    imageHeight: Get.height,
                    imageWidth: Get.width,
                  ),
                )),
                Visibility(
                  visible: true,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Visibility(
                          visible: _showAppbar,
                                                  child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      model.state.userName,
                                      style: TextStyle(
                                          fontFamily: "GoogleSans-Bold",
                                          fontSize: 30,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    Text("@name")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                height: 40,
                                width: Get.width - 100,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () {},
                                  child: Text("Follow"),
                                )),
                            Spacer(),
                            CircleIcon(
                              icon: FeatherIcons.messageCircle,
                              iconSize: 25,
                              onTap: () {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              buildUserInfo("Followers", 103),
                              SizedBox(width: 10),
                              buildUserInfo("Follows", 89),
                              SizedBox(width: 10),
                              buildUserInfo("Post", 34)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: Get.height,
                width: Get.width,
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  children: <Widget>[
                    //Expanded(flex: 1, child: Container()),
                    Expanded(
                        flex: 6,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: Get.width,
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                                child: TabBar(
                                    controller: tabController,
                                    indicatorColor: Colors.indigo,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    tabs: [Text("Post"), Text("Like"), Text("About")]),
                              ),
                              Flexible(
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Icon(Icons.directions_car),
                                    Icon(Icons.directions_transit),
                                    Icon(Icons.directions_bike),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                    // Setting blablabla....
                  ],
                ))
          ]))
        ],
      )*/
          ),
    );
  }
}

Widget buildUserInfo(String title, int number) {
  return Container(
    height: 50,
    width: 80,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            child: Text("$number", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Flexible(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w200),
          ),
        ),
      ],
    ),
  );
}

/*Widget buildUserInfo(String title, int number) {
  return Container(
    height: 50,
    width: 80,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration:
        BoxDecoration(color: brighten(Colors.black, 15), borderRadius: BorderRadius.circular(15)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w200),
        ),
        Text("$number", style: TextStyle(fontWeight: FontWeight.bold))
      ],
    ),
  );
}*/
