import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:get/get.dart';

class GroupCreatePost extends StatefulWidget {
  final String roomID;
  GroupCreatePost({this.roomID});
  @override
  _GroupCreatePostState createState() => _GroupCreatePostState();
}

class _GroupCreatePostState extends State<GroupCreatePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Row(
            children: [
              CircleIcon(
                icon: FeatherIcons.x,
                onTap: () {},
              ),
              Text("Create Post")
            ],
          ),
          preferredSize: Size.fromHeight(40)),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
