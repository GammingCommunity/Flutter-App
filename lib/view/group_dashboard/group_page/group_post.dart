import 'package:flutter/material.dart';
import 'package:gamming_community/view/group_dashboard/post_post_type/group_poll.dart';
import 'package:gamming_community/view/group_dashboard/post_post_type/group_post.dart';

class GroupPost extends StatefulWidget {
  final String roomID;
  GroupPost({this.roomID});
  @override
  _GroupPostState createState() => _GroupPostState();
}

class _GroupPostState extends State<GroupPost> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Text("Post"),
                  ),
                  Tab(
                    child: Text("Poll"),
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(60)),
          body: TabBarView(
            controller: _tabController,
            children: [GroupPostList(roomID: widget.roomID), GroupPollList(roomID: widget.roomID)],
          ),
        ));
  }
}
