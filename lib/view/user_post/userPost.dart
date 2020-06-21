import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:get/get.dart';

class UserPost extends StatefulWidget {
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  TextEditingController txtContent = TextEditingController();
  bool selected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          child: [
            Spacer(),
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
              child: Text("Post"),
            )
          ],
          height: 50,
          onNavigateOut: () => Get.back(),
          padding: EdgeInsets.only(right: 10),
          backIcon: FeatherIcons.x),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageBuilder: (context, imageProvider) => Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: imageProvider)),
                          ),
                      imageUrl: AppConstraint.default_profile),
                  SizedBox(width: 10),
                  Container(
                    height: Get.height,
                    width: Get.width - 60,
                    child: TextField(
                      controller: txtContent,
                      maxLines: 3,
                      decoration: InputDecoration.collapsed(
                          hintText: "Your content here", border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(5),
                color: brighten(AppColors.BACKGROUND_COLOR, 4),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleIcon(toolTip: "Image", icon: FeatherIcons.image, onTap: () {}),
                        CircleIcon(toolTip: "Video", icon: FeatherIcons.video, onTap: () {}),
                        CircleIcon(toolTip: "Gif", icon: FeatherIcons.save, onTap: () {}),
                        CircleIcon(toolTip: "Poll", icon: FeatherIcons.menu, onTap: () {}),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
