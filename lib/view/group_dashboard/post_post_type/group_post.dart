import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/group_dashboard/group_page/comment_page.dart';
import 'package:gamming_community/view/group_dashboard/provider/group_post_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class GroupPostList extends StatefulWidget {
  final String roomID;

  const GroupPostList({this.roomID});

  @override
  _GroupPostListState createState() => _GroupPostListState();
}

class _GroupPostListState extends State<GroupPostList> {
  GroupPostProvider _groupPostProvider;
  int like = 0;
  int comment = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _groupPostProvider.initLoadPost(widget.roomID);
    });
  }

  @override
  Widget build(BuildContext context) {
    _groupPostProvider = Injector.get();

    return Container(
      child: ListView.builder(
        itemCount: 1, //_groupPostProvider.countGroupPost,
        itemBuilder: (context, index) {
          return buildPostItem();
        },
      ),
    );
  }

  Widget buildPostItem() {
    return Container(
      height: 150,
      width: Get.width,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: AppConstraint.default_profile,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                  backgroundColor: Colors.grey,
                ),
                height: 50,
                width: 50,
              ),
              SizedBox(width: 10),
              Column(
                children: [Text("Username"), Text("12 min ago")],
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [Text("Content here")],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                Flexible(
                    child: LikeWidget(
                  isLike: _groupPostProvider.isLike,
                  number: 2,
                )),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleIcon(
                          icon: FeatherIcons.messageCircle,
                          onTap: () {
                            Get.to(CommentPage(
                              poster:"ABC",
                              commentID: "",
                            ));
                          }),
                      Text("5")
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LikeWidget extends StatefulWidget {
  final bool isLike;
  final int number;

  const LikeWidget({this.isLike, this.number});

  @override
  _LikeWidgetState createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  GroupPostProvider _groupPostProvider;
  @override
  Widget build(BuildContext context) {
    _groupPostProvider = Injector.get();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleIcon(
          icon: FeatherIcons.heart,
          iconColor: widget.isLike ? Colors.pink : Colors.white,
          onTap: () {
            if (widget.isLike) {
              _groupPostProvider.unLike();
            }
            _groupPostProvider.like();
          },
        ),
        Text(widget.number.toString())
      ],
    );
  }
}
