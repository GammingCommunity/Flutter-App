import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/room_manager/display_member.dart';
import 'package:gamming_community/view/room_manager/edit_room/edit_privacy.dart';
import 'package:gamming_community/view/room_manager/edit_room/game_info.dart';
import 'package:gamming_community/view/room_manager/edit_room/room_background.dart';
import 'package:gamming_community/view/room_manager/edit_room/room_game.dart';
import 'package:gamming_community/view/room_manager/edit_room/room_logo.dart';
import 'package:gamming_community/view/room_manager/edit_room/room_member.dart';
import 'package:gamming_community/view/room_manager/edit_room/save_button.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class EditRoom extends StatefulWidget {
  final String roomID;
  EditRoom({this.roomID});
  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  double numofMember = 0;
  bool isPrivate = false;
  TextEditingController roomNameController = TextEditingController();
  EditRoomProvider editProvider;
  TextEditingController numController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await editProvider.initLoading(widget.roomID);
      roomNameController.text = editProvider.roomName;
      numController.text = editProvider.maxofMember.toInt().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get(context: context);
    //super.build(context);
    return Scaffold(
      appBar: PreferredSize(
          child: Row(
            children: <Widget>[
              CircleIcon(
                icon: FeatherIcons.arrowLeft,
                iconSize: 20,
                onTap: () {
                  editProvider.clear();
                  Navigator.pop(context);
                },
              ),
              Text(
                "Edit Room",
                style: AppConstraint.textAppbar,
              ),
              Spacer(),
              Padding(
                  padding: EdgeInsetsResponsive.only(right: 10.0),
                  child: ButtonTheme(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: SaveButton()))
            ],
          ),
          preferredSize: Size.fromHeight(40)),
      body: SingleChildScrollView(
        child: ContainerResponsive(
          padding: EdgeInsetsResponsive.symmetric(vertical: 10, horizontal: 10),
          height: ScreenUtil().uiHeightPx,
          width: ScreenUtil().uiWidthPx,
          child: Column(
            children: <Widget>[
              // image holder, change image here
              Expanded(
                  flex: 3,
                  child: ContainerResponsive(
                    width: ScreenUtil().uiWidthPx,
                    child: Stack(
                      children: <Widget>[RoomBackground(), RoomLogo()],
                    ),
                  )),
              // info here
              Expanded(
                  flex: 8,
                  child: ContainerResponsive(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Room name",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                SizedBoxResponsive(height: 10.h),
                                ContainerResponsive(
                                  padding: EdgeInsetsResponsive.only(right: 10),
                                  height: 50.h,
                                  width: ScreenUtil().uiWidthPx / 2,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsetsResponsive.symmetric(horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(color: Colors.indigo)),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15))),
                                    controller: roomNameController,
                                  ),
                                ),
                              ],
                            ),
                            SizedBoxResponsive(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // set num of member

                                Text("Number of member",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                SizedBoxResponsive(height: 10.h),
                                ContainerResponsive(
                                    height: 50,
                                    width: 50,
                                    child: TextField(
                                        controller: numController,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        onSubmitted: (String value) {
                                          editProvider.setMaxOfMember(int.parse(value));
                                        },
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15),
                                                borderSide: BorderSide(color: Colors.indigo)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(15))))),
                              ],
                            )
                          ],
                        ),

                        // add or delete member here
                        Divider(),
                        Text("Member", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ContainerResponsive(
                            height: 80.h, width: ScreenUtil().uiWidthPx, child: RoomMember()),
                        // see game logo here, but can't modify
                        Divider(),
                        Text("Game", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBoxResponsive(height: 10.h),
                        RoomGame(),
                        Divider(),
                        // change privacy here
                        Text("Privacy",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ContainerResponsive(
                            height: 50,
                            child: EditPrivacy(
                              isPrivate: isPrivate,
                            )),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  /*@override
  bool get wantKeepAlive => true;*/
}
