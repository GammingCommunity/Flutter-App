import 'package:dotted_border/dotted_border.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/faslideAnimation.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/view/room/admin_tradio.dart';
import 'package:gamming_community/view/room/privacy_radio.dart';
import 'package:gamming_community/view/room/provider/setRoomBackground.dart';
import 'package:gamming_community/view/room_manager/room_create_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SelectRoomPrivacy extends StatefulWidget {
  final PageController pageController;
  SelectRoomPrivacy({this.pageController});

  @override
  _SelectPrivacyState createState() => _SelectPrivacyState();
}

class _SelectPrivacyState extends State<SelectRoomPrivacy> {
  bool canChangeName = true;
  bool isScroll = false;
  bool uploadPhoto = true;
  bool isRadioSelected = false;
  bool adminType = false;
  bool roomType = false; // false => public or true => private 
  var groupNameController = TextEditingController();
  var groupNameFocus = FocusNode();
  ScrollController scrollController;
  RoomCreateProvider roomCreateProvider;
  
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  double setTextSize (double size){
    return ScreenUtil().setSp(size);
  }
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    Color color = checkBrightness(context) ? Colors.black : Colors.white;
    roomCreateProvider = Injector.get(context: context);
    return ChangeNotifierProvider(
      create: (context) => SetRoomBackground(),
      child: Consumer<SetRoomBackground>(builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: Visibility(
              visible: value.checkroomName,
              child: FaSlideAnimation(
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
                          print("admin type : $adminType , roomtype : $roomType , roomname: ${groupNameController.text} ");
                          roomCreateProvider.setRoomPrivacy(roomType);
                          roomCreateProvider.setRoomName(groupNameController.text);
                          roomCreateProvider.submit();
                          // after submit , show progress, 
                          roomCreateProvider.isLoading ?? _openLoadingDialog;
                          // navigator.pop 

                          // add new room to room manager



                          //then open chat room. or sth else. 

                        },
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check,
                            color: color,
                          ),
                        ),
                      ),
                    )),
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: PreferredSize(
              child: Row(
                children: <Widget>[
                  CircleIcon(
                    icon: FeatherIcons.chevronLeft,
                    iconSize: 20,
                    onTap: () {
                      // go to previous page
                      widget.pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
                    },
                  )
                ],
              ),
              preferredSize: Size.fromHeight(30)),
          body: Material(
            child: SingleChildScrollView(
                controller: scrollController,
                physics:
                    AlwaysScrollableScrollPhysics() /*isScroll
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics()*/
                ,
                child: ContainerResponsive(
                  padding: EdgeInsetsResponsive.symmetric(horizontal: 20),
                  height: ScreenUtil().uiHeightPx,
                  width: ScreenUtil().uiWidthPx,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "GROUP NAME",
                          style: TextStyle(fontSize: setTextSize(20), fontWeight: FontWeight.bold),
                        ),
                        ContainerResponsive(
                          alignment: Alignment.center,
                          height: 40.h,
                          margin: EdgeInsets.only(bottom: 10),
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
                              decoration:
                                  InputDecoration.collapsed(hintText: "Enter your group name")),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Only admin can change groups name",
                                style: TextStyle(
                                    fontFamily: "GoogleSans-Medium", fontWeight: FontWeight.bold)),
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
                        SizedBoxResponsive(
                          height: 20,
                        ),
                        TextResponsive(
                          "ADD GROUP PICTURE",
                          style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),
                        ),
                        SizedBoxResponsive(
                          height: 40,
                        ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(15),
                          color: AppColors.PRIMARY_COLOR,
                          strokeWidth: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              height: 100,
                              child: uploadPhoto == true
                                  ? Stack(
                                      alignment: Alignment.centerLeft,
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            TextResponsive("Upload a photo",
                                                style: TextStyle(
                                                    fontFamily: "GoogleSans-Medium",
                                                    fontWeight: FontWeight.bold)),
                                            TextResponsive("Support .jpg or .png files")
                                          ],
                                        ),
                                        Positioned(
                                          right: 10,
                                          top: 10,
                                          child:
                                              IconButton(icon: Icon(Icons.photo), onPressed: () {}),
                                        )
                                      ],
                                    )
                                  : Image.asset(''),
                            ),
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
                          height: 40,
                        ),
                        // select room privacy type
                        ContainerResponsive(
                          alignment: Alignment.center,
                            height: 100.h,
                            child: Row(
                              children: <Widget>[
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
                                )
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
                          height: 20.h,
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
                                  content: "Anyone can invite pr delete guests",
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
                                  content: "Only people with permission can",
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
          ),
        );
      }),
    );
  }
}

void _openLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: CircularProgressIndicator(),
      );
    },
  );
}