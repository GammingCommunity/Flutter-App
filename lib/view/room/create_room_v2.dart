import 'package:flutter/material.dart';
import 'package:gamming_community/view/room/room_selector/selectGame.dart';
import 'package:gamming_community/view/room/room_selector/selectPrivacy.dart';


class CreateRoomV2 extends StatefulWidget {
  @override
  _CreateRoomV2State createState() => _CreateRoomV2State();
}

class _CreateRoomV2State extends State<CreateRoomV2> {
  int currentPage =1;
  PageController _pageController;

  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) => currentPage =value,
        children: <Widget>[
          SelectGame(),
          SelectRoomPrivacy()
        ],
      ),
    );
  }
}
