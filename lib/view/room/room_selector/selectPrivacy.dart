import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/borderIcon.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/faSlideAnimation_v2.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/utils/toListInt.dart';
import 'package:gamming_community/view/room/admin_tradio.dart';
import 'package:gamming_community/view/room/privacy_radio.dart';
import 'package:gamming_community/view/room/provider/setRoomBackground.dart';
import 'package:gamming_community/view/room/room_selector/search_member.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:gamming_community/view/room_manager/room_create_provider.dart';
import 'package:get/get.dart' as getX;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SelectRoomPrivacy extends StatefulWidget {
  final PageController pageController;
  SelectRoomPrivacy({this.pageController});

  @override
  _SelectPrivacyState createState() => _SelectPrivacyState();
}

class _SelectPrivacyState extends State<SelectRoomPrivacy> with TickerProviderStateMixin {
  bool canChangeName = true;
  bool isScroll = false;
  bool uploadPhoto = true;
  bool isRadioSelected = false;
  bool adminType = false; // true => free or false => closed
  bool roomType = false; // false => public or true => private
  bool removeItem = false;
  var groupNameController = TextEditingController();
  var searchFriendController = TextEditingController();
  var groupNameFocus = FocusNode();
  ScrollController scrollController;
  RoomCreateProvider roomCreateProvider;
  RoomManagerBloc roomManagerBloc;
  AnimationController animationController;
  Animation fadeAnimation;
  ImagePicker imagePicker = ImagePicker();
  final keys = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  double setTextSize(double size) {
    return ScreenUtil().setSp(size);
  }

  Future pickAvatar() async {
    try {
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      roomManagerBloc.add(SetAvatar(path: image.path));
    } catch (e) {}
  }

  Future pickCover() async {
    try {
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      roomManagerBloc.add(SetCover(path: image.path));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    roomCreateProvider = Injector.get(context: context);
    roomManagerBloc = BlocProvider.of<RoomManagerBloc>(context);

    return ChangeNotifierProvider(
      create: (context) => SetRoomBackground(),
      child: Consumer<SetRoomBackground>(builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: Visibility(
              visible: value.checkroomName,
              child: FaSlideAnimation.slideUp(
                delayed: 200,
                show: value.checkroomName,
                child: SizedBoxResponsive(
                    width: 60.w,
                    height: 60.h,
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.indigo,
                      child: InkWell(
                        onTap: () {
                          // submit info to server
                          //print("admin type : $adminType , roomtype : $roomType , roomname: ${groupNameController.text} ");
                          //roomCreateProvider.setRoomPrivacy(roomType);
                          //.setRoomName(groupNameController.text);
                          //roomCreateProvider.submit();
                          // after submit , show progress,
                          //roomCreateProvider.isLoading ?? _openLoadingDialog;
                          // navigator.pop

                          // add new room to room manager
                          roomManagerBloc.add(AddRoom(
                              coverPath: roomManagerBloc.coverPath,
                              avatarPath: roomManagerBloc.avatarPath,
                              member: toListString(roomManagerBloc.users),
                              adminType: adminType,
                              gameID: roomCreateProvider.gameID,
                              hostID: roomCreateProvider.hostID,
                              roomType: roomType ? "private" : "public",
                              numofMember: roomCreateProvider.numofMember,
                              roomName: groupNameController.text));

                          //then open chat room. or sth else.
                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: CustomAppBar(
              child: [],
              height: 40,
              onNavigateOut: () {
                widget.pageController.animateToPage(0,
                    duration: Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
              },
              padding: EdgeInsets.all(0),
              backIcon: FeatherIcons.arrowLeft),
          body: SingleChildScrollView(
              controller: scrollController,
              physics:
                  AlwaysScrollableScrollPhysics() /*isScroll
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics()*/
              ,
              child: ContainerResponsive(
                color: AppColors.BACKGROUND_COLOR,
                padding: EdgeInsetsResponsive.symmetric(horizontal: 20, vertical: 10),
                width: getX.Get.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextResponsive(
                        "GROUP IMAGE",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                      ),
                      SizedBoxResponsive(
                        height: 30,
                      ),
                      Container(
                          // padding: EdgeInsets.all(20),
                          height: 100,
                          child: BlocListener<RoomManagerBloc, RoomManagerState>(
                              listener: (context, state) {},
                              child: BlocBuilder<RoomManagerBloc, RoomManagerState>(
                                  builder: (context, state) {
                                if (state is SetCoverSuccess) {}
                                if (state is SetAvatarSuccess) {}

                                return Row(
                                  children: [
                                    DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(15),
                                      color: AppColors.PRIMARY_COLOR,
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        padding: EdgeInsets.all(5),
                                        child: roomManagerBloc.avatarPath == ""
                                            ? CircleIcon(
                                                icon: FeatherIcons.image,
                                                onTap: () async {
                                                  //avatar
                                                  await pickAvatar();
                                                })
                                            : Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.asset(roomManagerBloc.avatarPath,
                                                        fit: BoxFit.cover, height: 100, width: 100),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: InkWell(
                                                      child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.amber,
                                                          ),
                                                          child: Icon(
                                                            FeatherIcons.x,
                                                            color: Colors.black,
                                                          )),
                                                      onTap: () {
                                                        roomManagerBloc.add(UnsetAvatar());
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                        child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(15),
                                            color: AppColors.PRIMARY_COLOR,
                                            strokeWidth: 1,
                                            child: ClipRRect(
                                              child: Container(
                                                width: getX.Get.width,
                                                height: 100,
                                                padding: EdgeInsets.all(5),
                                                child: roomManagerBloc.coverPath == ""
                                                    ? CircleIcon(
                                                        icon: FeatherIcons.image,
                                                        onTap: () async {
                                                          //background
                                                          await pickCover();
                                                        })
                                                    : Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: Image.asset(
                                                                roomManagerBloc.coverPath,
                                                                height: 100,
                                                                fit: BoxFit.cover,
                                                                width: getX.Get.width),
                                                          ),
                                                          Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: InkWell(
                                                              child: Container(
                                                                  height: 30,
                                                                  width: 30,
                                                                  alignment: Alignment.center,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: Colors.amber,
                                                                  ),
                                                                  child: Icon(
                                                                    FeatherIcons.x,
                                                                    color: Colors.black,
                                                                  )),
                                                              onTap: () {
                                                                roomManagerBloc.add(UnsetCover());
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                              ),
                                            )))
                                  ],
                                );
                              }))),

                      SizedBoxResponsive(
                        height: 40,
                      ),
                      Text(
                        "GROUP NAME",
                        style: TextStyle(fontSize: setTextSize(20), fontWeight: FontWeight.bold),
                      ),
                      ContainerResponsive(
                        alignment: Alignment.center,
                        height: 50.h,
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                            onEditingComplete: () {
                              // TODO : Implement check group name here
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (String val) {
                              
                              val.isEmpty ? value.roomNameSate(false) : value.roomNameSate(true);
                            },
                            focusNode: groupNameFocus,
                            controller: groupNameController,
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter your group name",
                                hintStyle: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Only admin can change groups name",
                              style: TextStyle(
                                  fontFamily: "GoogleSans-Regular", fontWeight: FontWeight.bold)),
                          Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: canChangeName,
                              onChanged: (bool val) {
                                setState(() {
                                  canChangeName = val;
                                });
                              })
                        ],
                      ),

                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "PICK MEMBER",
                        style: TextStyle(fontSize: setTextSize(20), fontWeight: FontWeight.bold),
                      ),
                      SizedBoxResponsive(
                        height: 30,
                      ),
                      DottedBorder(
                        borderType: BorderType.RRect,
                        radius: Radius.circular(15),
                        color: AppColors.PRIMARY_COLOR,
                        strokeWidth: 1,
                        child: ClipRRect(
                          child: Container(
                              width: getX.Get.width,
                              height: 100,
                              child: BlocListener<RoomManagerBloc, RoomManagerState>(
                                  listener: (context, state) {},
                                  child: BlocBuilder<RoomManagerBloc, RoomManagerState>(
                                      builder: (context, state) {
                                    if (state is AddMemberSuccess) {}
                                    if (state is RemoveMemberSuccess) {}
                                    return Container(
                                      width: getX.Get.width,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child:
                                                /*AnimatedList(
                                            initialItemCount: roomManagerBloc.users.length,
                                            padding: EdgeInsets.only(left: 10),
                                            key: keys,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index, animation) {
                                              List<User> users = roomManagerBloc.users;
                                              return users.isEmpty
                                                  ? Container()
                                                  : 
                                            },
                                          )*/

                                                ListView.separated(
                                              cacheExtent: 20,
                                              separatorBuilder: (context, index) =>
                                                  SizedBox(width: 10),
                                              padding: EdgeInsets.only(left: 10),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: roomManagerBloc.users.length,
                                              itemBuilder: (context, index) {
                                                List<User> users = roomManagerBloc.users;
                                                return InkWell(
                                                  onTap: () {},
                                                  child: Center(
                                                    child: Container(
                                                      width: 80,
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(15),
                                                                child: CachedNetworkImage(
                                                                    height: 60,
                                                                    width: 60,
                                                                    fit: BoxFit.cover,
                                                                    imageUrl:
                                                                        users[index].profileUrl ??
                                                                            AppConstraint
                                                                                .default_profile),
                                                              ),
                                                              SizedBox(height: 5),
                                                              Flexible(
                                                                  child: Text(
                                                                users[index].nickname,
                                                                overflow: TextOverflow.ellipsis,
                                                              ))
                                                            ],
                                                          ),
                                                          Positioned(
                                                              top: 5,
                                                              right: 5,
                                                              child: InkWell(
                                                                child: Container(
                                                                    height: 30,
                                                                    width: 30,
                                                                    alignment: Alignment.center,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color: Colors.amber,
                                                                    ),
                                                                    child: Icon(
                                                                      FeatherIcons.x,
                                                                      color: Colors.black,
                                                                    )),
                                                                onTap: () {
                                                                  roomManagerBloc.add(RemoveMember(
                                                                      id: users[index].id));
                                                                },
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          roomManagerBloc.users.isEmpty
                                              ? Padding(
                                                  padding: const EdgeInsets.only(left: 20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      TextResponsive("Pick your member",
                                                          style: TextStyle(
                                                              fontFamily: "GoogleSans-Medium",
                                                              fontWeight: FontWeight.bold)),
                                                      TextResponsive("You can change member later")
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: CircleIcon(
                                                  icon: FeatherIcons.plus,
                                                  onTap: () async {
                                                    List<User> ids = await getX.Get.to(
                                                        SearchMember(),
                                                        transition: getX.Transition.leftToRight);
                                                    roomManagerBloc.add(AddMember(user: ids));
                                                  }))
                                        ],
                                      ),
                                    );
                                  }))),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "ADD GROUP TYPE",
                        style: TextStyle(fontSize: setTextSize(20), fontWeight: FontWeight.bold),
                      ),
                      SizedBoxResponsive(
                        height: 20,
                      ),
                      // select room privacy type
                      ContainerResponsive(
                          alignment: Alignment.center,
                          height: 110.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              PrivacyRadio(
                                selected: isRadioSelected,
                                value: true,
                                privacyType: "Public",
                                content: "Anyone can join this group",
                                groupValue: isRadioSelected,
                                onChangeType: (bool val) {
                                  setState(() {
                                    isRadioSelected = val;
                                  });
                                },
                                onChanged: (bool val) {
                                  setState(() {
                                    isRadioSelected = val;
                                  });
                                },
                              ),
                              SizedBox(width: 20),
                              PrivacyRadio(
                                privacyType: "Private",
                                selected: !isRadioSelected,
                                value: false,
                                content: "Only people with access can join group",
                                groupValue: isRadioSelected,
                                onChangeType: (bool val) {
                                  setState(() {
                                    roomType = val;
                                    isRadioSelected = val;
                                  });
                                },
                                onChanged: (bool val) {
                                  setState(() {
                                    roomType = val;
                                    isRadioSelected = val;
                                  });
                                },
                              ),
                              /*SizedBox(width: 20),
                              PrivacyRadio(
                                privacyType: "Hidden",
                                selected: !isRadioSelected,
                                value: false,
                                content: "No one can search except HOST",
                                groupValue: isRadioSelected,
                                onChangeType: (bool val) {
                                  setState(() {
                                    roomType = val;
                                    isRadioSelected = val;
                                  });
                                },
                                onChanged: (bool val) {
                                  setState(() {
                                    roomType = val;
                                    isRadioSelected = val;
                                  });
                                },
                              ),*/
                            ],
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "SELECT ADMIN TYPE",
                        style: TextStyle(fontSize: setTextSize(20), fontWeight: FontWeight.bold),
                      ),

                      SizedBoxResponsive(
                        height: 10.h,
                      ),
                      // select admin type
                      ContainerResponsive(
                          height: 150.h,
                          child: Row(
                            children: <Widget>[
                              AdminRadio(
                                selected: adminType,
                                value: true,
                                privacyType: "Free",
                                content: "Anyone can post in group",
                                groupValue: adminType,
                                onChangeType: (bool val) {
                                  setState(() {
                                    adminType = val;
                                  });
                                },
                                onChanged: (bool val) {
                                  setState(() {
                                    adminType = val;
                                  });
                                },
                              ),
                              SizedBox(width: 20),
                              AdminRadio(
                                privacyType: "Closed",
                                selected: !adminType,
                                value: false,
                                content: "Your post must approve first",
                                groupValue: adminType,
                                onChangeType: (bool val) {
                                  setState(() {
                                    adminType = val;
                                  });
                                },
                                onChanged: (bool val) {
                                  setState(() {
                                    adminType = val;
                                  });
                                },
                              )
                            ],
                          )),
                    ]),
              )),
        );
      }),
    );
  }
}
