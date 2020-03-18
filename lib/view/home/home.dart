import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/view/dashboard/dashboard.dart';
import 'package:gamming_community/view/messages/messages.dart';
import 'package:gamming_community/view/profile/profile.dart';
import 'package:gamming_community/view/room/summary_room.dart';
import 'package:gamming_community/view/room_manager/room_manager.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _currentIndex = 0;
  String userID;
  String userProfile,userName;
  PageController _pageController;
  List<Widget> _listWidget = [];

  @override
  void initState() {
    //print(userID);

    super.initState();
    getUserInfo().then((value) => {
          _listWidget = [
            DashBoard(),
            SummaryRoom(),
            RoomManager(),
            Messages(
              userID: userID,
            ),
            Profile(userID: userID,userName:userName ,userProfile: userProfile)
          ]
        });

    _pageController = PageController();
  }

  Future getUserInfo() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    //List<String> res = ref.getStringList("userToken");

    setState(() {
      userID = ref.getString("userID");
      userProfile = ref.getString("userProfile");
      userName= ref.getString("userName");
    });

    //print("get profile home $userProfile");
    return [userID, userProfile];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (int index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
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
              icon: Icon(Icons.supervised_user_circle),
              title: Text("Profile"),
              inactiveColor: Colors.white),
        ],
      ),
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
    
    );
  }
}
