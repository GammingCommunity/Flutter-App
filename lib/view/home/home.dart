import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gamming_community/class/ReceiveNotfication.dart';
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
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gamming_community/view/room/explorer_room.dart';
import 'package:tuple/tuple.dart';


class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  String userID;
  String userProfile, userName,token;
  var searchController = TextEditingController();
  Animation<double> _animation;
  AnimationController controller;
  PageController _pageController;
  List<Widget> _listWidget = [];
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

  
  @override
  void initState() {
    //print(userID);

    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
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
    
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid,null);
    
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
    return [userID, userProfile,userName,token];
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
    return Selector2<Search, NotificationModel, Tuple2<bool, bool>>(
        selector: (_, search, notify) => Tuple2(search.isHideSearch, notify.isSeen),
        builder: (context, value, child) => Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Visibility(
                  maintainAnimation: true,
                  maintainState: true,
                  visible: value.item1,
                  child: Container(
                      width: screenSize.width,
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: AppColors.NAVIGATION_BAR_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration.collapsed(hintText: "Search here ..."),
                            ),
                          ),
                          Material(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.transparent,
                            child: IconButton(
                                icon: Icon(OpenIconicIcons.bell),
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(maintainState: true,builder: (context) => Notfications()));
                                  notification.seen(true);
                                }),
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
                              borderRadius: BorderRadius.circular(1000),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                imageUrl: userProfile ?? AppConstraint.default_profile,
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                      color: Colors.grey[400]),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              bottomNavigationBar: Container(
                  child: Stack(
                children: <Widget>[
                  GNav(
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    duration: Duration(milliseconds: 800),
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
                            duration: Duration(milliseconds: 200), curve: Curves.easeInToLinear);
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
                decoration: BoxDecoration(color: Color(0xff322E2E)),
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
            ));
  }

  @override
  
  bool get wantKeepAlive => true;
}
