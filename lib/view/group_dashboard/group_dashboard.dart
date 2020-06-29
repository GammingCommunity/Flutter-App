import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/CountRoom.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/iconWithTitle.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/view/group_dashboard/group_page/group_message.dart';
import 'package:gamming_community/view/group_dashboard/group_page/group_post.dart';
import 'package:gamming_community/view/messages/models/group_chat_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'group_create_post/group_create_post.dart';

class GroupDashboard extends StatefulWidget {
  final GroupChat room;
  final String currenID;
  final List member;

  const GroupDashboard({this.room, this.currenID, this.member});

  @override
  _GroupDashboardState createState() => _GroupDashboardState();
}

class _GroupDashboardState extends State<GroupDashboard> {
  PageController pageController;
  GroupChatProvider groupChatProvider;
  int _pageIndex = 0;
  @override
  void initState() {
    pageController = PageController()
      ..addListener(() {
        print(pageController.page);
      });
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      await groupChatProvider.initMember(widget.member, widget.room.id);
     
    });
    super.initState();
  }

  showGroupBottomSheet() {
    return Get.bottomSheet(
        Container(
            height: 150,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FeatherIcons.minus),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  IconWithTitle(
                      borderRadius: 15,
                      icon: FeatherIcons.gitMerge,
                      color: Colors.blueGrey,
                      title: "Create post",
                      titlePosition: Position.bottom,
                      onTap: () {
                        print("create post");
                        Get.to(
                            GroupCreatePost(
                              roomID: widget.room.id,
                            ),
                            transition: Transition.downToUp);
                      }),
                  IconWithTitle(
                    icon: FeatherIcons.barChart2,
                    iconSize: 20,
                    color: Color(0xff3282b8),
                    borderRadius: 20,
                    titlePosition: Position.bottom,
                    title: "Create poll",
                    onTap: () {},
                  ),
                ]),
              ],
            )),
        useRootNavigator: true,
        backgroundColor: Get.isDarkMode ? AppColors.BACKGROUND_COLOR : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))));
  }

  @override
  Widget build(BuildContext context) {
    groupChatProvider = Injector.get(context: context);
    return Scaffold(
        bottomNavigationBar: Container(
          height: _pageIndex == 1 ? 0 : 100,
          width: Get.width,
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: FloatingActionButton(
                    onPressed: () {
                      showGroupBottomSheet();
                    },
                    child: Icon(FeatherIcons.plus),
                  )),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    height: Get.height,
                    decoration: BoxDecoration(
                        color: brighten(AppColors.BACKGROUND_COLOR, 10),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleIcon(
                          icon: FeatherIcons.archive,
                          onTap: () {},
                        ),
                        CircleIcon(
                          icon: FeatherIcons.messageCircle,
                          onTap: () {
                            Get.to(GroupMessageWidget(
                              roomName: widget.room.roomName,
                              roomID: widget.room.id,
                              currentID: widget.currenID,
                              member: widget.room.memberID,
                            ));
                          },
                        ),
                        CircleIcon(
                          icon: FeatherIcons.search,
                          onTap: () {},
                        ),
                        CircleIcon(
                          icon: FeatherIcons.settings,
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Container(height: Get.height, width: Get.width, child: GroupPost()
            /*PageView(
            controller: pageController,
            onPageChanged: (index) {
              print(index);
              setState(() {
                _pageIndex = index;
              });
            },
            children: [GroupPost(), GroupMessageWidget()],
          ),*/
            ));
  }
}
