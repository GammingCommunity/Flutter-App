import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/specify_room_game/join_button.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RoomItem extends StatefulWidget {
  final GroupChat room;
  RoomItem({this.room});
  @override
  _RoomItemState createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var rooms = widget.room;
    var v = DateTime.now().difference(DateTime.tryParse(rooms.createAt).toLocal());
    super.build(context);
    return FaSlideAnimation.slideUp(
        show: true,
        delayed: 100,
        child: InkWell(
          onTap: () {},
          child: ContainerResponsive(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstraint.container_border_radius)),
            width: ScreenUtil().uiWidthPx,
            height: 100.h,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsetsResponsive.symmetric(horizontal: 5),
                  child: Stack(
                    children: <Widget>[
                      //logo room
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 60.h,
                              width: 60.w,
                              //fadeInCurve: Curves.easeIn,
                              fadeInDuration: Duration(seconds: 2),
                              imageUrl: rooms.roomLogo,
                              placeholder: (context, url) =>
                                  SkeletonTemplate.image(60.h, 60.w, 1000, Colors.grey),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      // room information
                      Positioned(
                        left: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Wrap(
                              direction: Axis.vertical,
                              spacing: 10,
                              runAlignment: WrapAlignment.start,
                              children: <Widget>[
                                Text(
                                  rooms.roomName ?? "Room name",
                                  style: TextStyle(fontSize: ScreenUtil().setSp(18)),
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${v.inHours} hours ago")),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    DisplayMember(
                                      borderRadius: 1000,
                                      size: 30,
                                      ids: rooms.memberID,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: ContainerResponsive(
                            height: 30.h,
                            alignment: Alignment.center,
                            width: 50.w,
                            decoration: BoxDecoration(
                                color: Colors.indigo, borderRadius: BorderRadius.circular(15)),
                            child: Text(
                                "${rooms.memberID.length}/ ${rooms.maxOfMember}",style: TextStyle(color: !checkBrightness(context) ? Colors.white : Colors.black,)),)
                      )
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: ProgressButtons(
                    setCircle: true,
                    buttonHeight: 30,
                    buttonWidth: 60,
                    isJoin: rooms.isJoin,
                    isRequest: rooms.isRequest,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          FeatherIcons.plus,
                          size: 15,
                        ),
                        Text("Join")
                      ],
                    ),
                    info: {"hostID": rooms.hostID, "roomID": rooms.id},
                    onPressed: () {},
                    onSuccess: (value) {
                      value == 1 ??
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            return showResultDialog(context, "Wait for approve.");
                          });
                    },
                    onError: (value) {
                      print("join room err : $value");
                    },
                  ),
                ))
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
showResultDialog(BuildContext context, String content) {
  return showDialog(
    context: context,
    builder: (context) => ContainerResponsive(
        height: 150.h,
        width: 200.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: SimpleDialog(
          children: <Widget>[
            Icon(
              FeatherIcons.checkCircle,
              size: 30,
            ),
            SizedBoxResponsive(height: 10),
            Align(alignment: Alignment.center, child: Text(content)),
          ],
        )),
  );
}
