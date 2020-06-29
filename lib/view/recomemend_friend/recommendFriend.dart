import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:get/get.dart';

class RecommendFriends extends StatefulWidget {
  @override
  _RecommendFriendsState createState() => _RecommendFriendsState();
}

class _RecommendFriendsState extends State<RecommendFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          child: [
            
          ],
          height: 50,
          onNavigateOut: () => Get.back(),
          padding: EdgeInsets.all(0),
          backIcon: FeatherIcons.arrowLeft),
          body: Container(
            height: Get.height,
            width: Get.width
          ),
    );
  }
}
