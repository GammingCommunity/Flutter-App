import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/class/ReceiveNotfication.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/provider/notficationModel.dart';
import 'package:gamming_community/provider/search_bar.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/dashboard/dashboard.dart';
import 'package:gamming_community/view/messages/messages.dart';
import 'package:gamming_community/view/notfications/notfications.dart';
import 'package:gamming_community/view/profile/profile.dart';
import 'package:gamming_community/view/room_manager/room_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamming_community/view/room/explorer_room.dart';
import 'package:tuple/tuple.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  String userID;
  String userProfile, userName, token;
  var searchController = TextEditingController();
  AnimationController controller;
  PageController _pageController;
  List<Widget> _listWidget = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  @override
  void initState() {
    //print(userID);

    super.initState();

    getUserInfo().then((value) => {
          _listWidget = [
            DashBoard(),
            Explorer(),
            RoomManager(
              token: token,
            ),
            Messages(
              userID: userID,
              token: token,
            )
            //Profile(userID: userID, userName: userName, userProfile: userProfile)
          ]
        });

    _pageController = PageController();
  }

  Future initNotfication() async {
    NotificationAppLaunchDetails notificationAppLaunchDetails;
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class

    var initializationSettings = InitializationSettings(initializationSettingsAndroid, null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  Future getUserInfo() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    //List<String> res = ref.getStringList("userToken");

    setState(() {
      token = ref.getStringList("userToken")[2];
      userID = ref.getString("userID");
      userProfile = ref.getString("userProfile");
      userName = ref.getString("userName");
    });

    //print("get profile home $userProfile");
    return [userID, userProfile, userName, token];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var notification = Provider.of<NotificationModel>(context);
    super.build(context);
    ResponsiveWidgets.init(context,
        allowFontScaling: true, height: screenSize.height, width: screenSize.width);
    return ResponsiveWidgets.builder(
      allowFontScaling: true,
      height: screenSize.height,
      width: screenSize.width,
      child: Selector2<Search, NotificationModel, Tuple2<bool, bool>>(
          selector: (_, search, notify) => Tuple2(search.isHideSearch, notify.isSeen),
          builder: (context, value, child) => Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child: Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: value.item1,
                    child: ContainerResponsive(
                        width: screenSize.width,
                        height: 50,
                        padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration.collapsed(hintText: "Search here ..."),
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                CircleIcon(
                                  icon: FeatherIcons.bell,
                                  iconSize: 20,
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        maintainState: true, builder: (context) => Notfications()));
                                    notification.seen(true);
                                  },
                                ),
                                //TODO: fetch notifcation
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child: ContainerResponsive(
                                        height: 20.h,
                                        width: 20.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.indigo,
                                        ),
                                        alignment: Alignment.center,
                                        child: TextResponsive(
                                          "99",
                                          style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryTextTheme.bodyText1.color),
                                        )
                                    )
                                )
                              ],
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(1000),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: Profile(
                                            userID: userID,
                                            userName: userName,
                                            userProfile: userProfile),
                                        type: PageTransitionType.fade,
                                        alignment: Alignment.center));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10000),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  height: 30,
                                  width: 30,
                                  imageUrl: userProfile ?? AppConstraint.default_profile,
                                  placeholder: (context, url) => Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10000),
                                        color: Colors.grey[400]),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
                bottomNavigationBar: ContainerResponsive(
                    height: 50,
                    child: Stack(
                      children: <Widget>[
                        GNav(
                          gap: 8,
                          activeColor: Colors.white,
                          iconSize: 24,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          duration: Duration(milliseconds: 500),
                          tabBackgroundColor: Colors.indigo,
                          tabMargin: EdgeInsets.only(bottom: 5),
                          tabs: [
                            GButton(
                              text: "Dashboard",
                              icon: OpenIconicIcons.dashboard,
                            ), //dashboard
                            GButton(
                              text: "Explorer",
                              icon: OpenIconicIcons.compass,
                            ), // home
                            GButton(text: "Manager", icon: OpenIconicIcons.globe), // explorer
                            GButton(text: "Chat", icon: OpenIconicIcons.chat), // chat
                            // notificaiton
                          ],
                          onTabChange: (index) => {
                            setState(() {
                              _currentIndex = index;
                              _pageController.animateToPage(index,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInToLinear);
                            })
                          },
                          selectedIndex: _currentIndex,
                        )
                      ],
                    ))

                /*BottomNavyBar(
                  selectedIndex: _currentIndex,
                  onItemSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                      _pageController.animateToPage(index,
                          duration: Duration(milliseconds: 200), curve: Curves.easeInToLinear);
                    });
                  },
                  items: [
                    BottomNavyBarItem(
                        textAlign: TextAlign.center,
                        icon: Icon(Icons.dashboard),
                        title: Text("Dashboard"),
                        inactiveColor: Colors.white),
                    BottomNavyBarItem(
                        textAlign: TextAlign.center,
                        icon: Icon(OpenIconicIcons.task),
                        title: Text("Explore"),
                        inactiveColor: Colors.white),
                    BottomNavyBarItem(
                        textAlign: TextAlign.center,
                        icon: Icon(OpenIconicIcons.spreadsheet),
                        title: Text("Manager"),
                        inactiveColor: Colors.white),
                    BottomNavyBarItem(
                        textAlign: TextAlign.center,
                        icon: Icon(OpenIconicIcons.chat),
                        title: Text("Message"),
                        inactiveColor: Colors.white),
                    BottomNavyBarItem(
                        textAlign: TextAlign.center,
                        icon: Icon(OpenIconicIcons.bell),
                        title: Text("Notfication"),
                        inactiveColor: Colors.white),
                  ],
                )*/
                ,
                body: Container(
                  height: screenSize.height,
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    controller: _pageController,
                    children: _listWidget,
                  ),
                ),
              )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
