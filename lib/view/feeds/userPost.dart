import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/Post.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/displayAvatar.dart';
import 'package:gamming_community/utils/customDateTime.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPost extends StatefulWidget {
  final Post post;
  UserPost({this.post});
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> with AutomaticKeepAliveClientMixin {
  double profileSize = 40;
  String userName = "";

  Future getName() async {
    SharedPreferences ref = await SharedPreferences.getInstance();
    return ref.getString("userName");
  }

  @override
  void initState() {
    super.initState();

    getName().then((value) => setState(() {
          userName = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: widget.post.media.isEmpty ? 155 : 400,
      width: ScreenUtil().uiWidthPx,
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
        BoxShadow(blurRadius: 0.1, color: Colors.grey.withOpacity(0.1), offset: Offset(0, 1))
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //avatar
          Row(
            children: <Widget>[
              DisplayAvatar(size: profileSize),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    userName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("@Tag here")
                ],
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      FeatherIcons.clock,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text("${customDateTime(widget.post.createdTime)}")
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: <Widget>[Text(widget.post.content)],
            ),
          ),
          Container(
            
            width: Get.width,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: false
              ),
              itemCount: widget.post.media.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: Get.width,
                      imageUrl: widget.post.media[index],
                      fadeInCurve: Curves.fastOutSlowIn,
                      placeholder: (context, url) => SkeletonTemplate.image(100, Get.width, 15),
                    ),
                  ),
                );
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleIcon(
                      icon: FeatherIcons.thumbsUp,
                      iconSize: 20,
                      onTap: () {},
                    ),
                    Text(widget.post.countReaction.toString())
                  ],
                ),
                SizedBox(width: 10),
                Row(
                  children: <Widget>[
                    CircleIcon(
                      icon: FeatherIcons.messageCircle,
                      iconSize: 20,
                      onTap: () {},
                    ),
                    Text(widget.post.countComment.toString())
                  ],
                ),
              ],
            ),
          ),

          // content
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
