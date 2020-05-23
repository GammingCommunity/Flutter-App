import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/Post.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/displayAvatar.dart';
import 'package:gamming_community/utils/customDateTime.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPost extends StatefulWidget {
  final Post post;
  UserPost({this.post});
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
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
    return Container(
      height: widget.post.media == "" ? 155 : 200,
      width: ScreenUtil().uiWidthPx,
      padding: EdgeInsets.only(top: 20, bottom: 10,left:20,right:20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
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
                      SizedBox(width:10),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleIcon(
                      icon: FeatherIcons.thumbsUp,
                      iconSize: 15,
                      onTap: () {

                      },
                    ),
                    Text(widget.post.countReaction.toString())
                  ],
                ),
                Row(
                  children: <Widget>[
                    CircleIcon(
                      icon: FeatherIcons.messageCircle,
                      iconSize: 15,
                      onTap: () {},
                    ),
                    Text(widget.post.countComment.toString())
                  ],
                ),
              ],
            ),
          )
          // content
        ],
      ),
    );
  }
}
