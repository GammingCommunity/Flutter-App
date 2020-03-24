import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/room/admin_tradio.dart';
import 'package:gamming_community/view/room/privacy_radio.dart';
import 'package:gamming_community/view/room/provider/setRoomBackground.dart';
import 'package:provider/provider.dart';

class SelectRoomPrivacy extends StatefulWidget {
  @override
  _SelectPrivacyState createState() => _SelectPrivacyState();
}

class _SelectPrivacyState extends State<SelectRoomPrivacy> {
  bool canChangeName = true;
  bool isScroll = false;
  bool uploadPhoto = true;
  bool isRadioSelected = false;
  bool adminType = false;
  var groupNameController = TextEditingController();
  var groupNameFocus = FocusNode();
  ScrollController scrollController;
  
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
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => SetRoomBackground(),
      child: Consumer<SetRoomBackground>(builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: Visibility(
              visible: value.checkroomName,
              child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.indigo,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                        alignment: Alignment.center,
                        child: Icon(Icons.check),
                      ),
                    ),
                  ))),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          appBar: PreferredSize(
              child: Row(
                children: <Widget>[
                  Material(
                      color: Colors.transparent,
                      type: MaterialType.circle,
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        icon: Icon(Icons.chevron_left),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ))
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
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: screenSize.height,
                  width: screenSize.width,
                  child: Column(
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "GROUP NAME",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 60,
                              margin: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                  onEditingComplete: () {
                                    // TODO : Implement check group name here
                                    FocusScope.of(context).unfocus();
                                  },
                                  onChanged: (String val) {
                                    val.isEmpty
                                        ? value.roomNameSate(false)
                                        : value.roomNameSate(true);
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
                                        fontFamily: "GoogleSans-Medium",
                                        fontWeight: FontWeight.bold)),
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
                              "ADD GROUP PICTURE",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
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
                                                Text("Upload a photo",
                                                    style: TextStyle(
                                                        fontFamily: "GoogleSans-Medium",
                                                        fontWeight: FontWeight.bold)),
                                                Text("Support .jpg or .png files")
                                              ],
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: IconButton(
                                                  icon: Icon(Icons.photo), onPressed: () {}),
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
                              "ADD GROUP PICTURE",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // select room privacy type
                            Container(
                                height: 150,
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
                                          isRadioSelected = val;
                                        });
                                      },
                                      onChanged: (bool val) {
                                        setState(() {
                                          isRadioSelected = val;
                                        });
                                      },
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "SELECT ADMIN TYPE",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // select admin type
                            Container(
                                height: 150,
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
                    ],
                  ),
                )),
          ),
        );
      }),
    );
  }
}
