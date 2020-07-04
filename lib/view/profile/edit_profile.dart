import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/provider/changeProfile.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/progress_button.dart';
import 'package:gamming_community/view/profile/load_image.dart';
import 'package:gamming_community/view/profile/load_image_network.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// global variable
bool isShownBottomAvatar = false;

GraphQLMutation mutation = GraphQLMutation();

class EditProfile extends StatefulWidget {
  final String userID, currentProfile;
  EditProfile({this.userID, this.currentProfile});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nickname = TextEditingController();
  TextEditingController _personalInfo = TextEditingController();
  TextEditingController _birthday = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _email = TextEditingController();
  FocusNode _nickNameFocus = FocusNode();
  FocusNode _personalInfoFocus = FocusNode();
  FocusNode _birthdayFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  DateTime selectedDate = DateTime.now();
  GraphQLQuery query = GraphQLQuery();

  void selectDay(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1991),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _birthday.text = ("${picked.day} / ${picked.month} / ${picked.year}");
      });
  }

  Future getProfileInfo() async {
    var result = await SubRepo.queryGraphQL(await getToken(), query.getCurrentUserInfo());
    User user = User.fromJson(result.data["getThisAccount"]);
    if (mounted) {
      setState(() {
        _nickname.text = user.nickname;
        _personalInfo.text = user.describe;
        _phone.text = user.phoneNumber;
      });
    }
  }

  @override
  void dispose() {
    _nickname.dispose();
    _birthday.dispose();
    _phone.dispose();
    _personalInfo.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Discard change?', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text("You'll lose any changes you've made to your profile."),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Disard Changes?',
                      style: TextStyle(color: AppColors.PRIMARY_COLOR),
                    ),
                  ),
                ],
              )
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final screenSize = MediaQuery.of(context).size;
    //final getImage = Provider.of<ChangeProfile>(context);
    return Consumer<ChangeProfile>(
      builder: (context, getImage, child) {
        return Scaffold(
            key: scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: Container(
                child: Row(
                  children: <Widget>[
                    CircleIcon(
                      icon: Icons.chevron_left,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    Text(
                      "Edit Profile",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    ProgressButton(
                      userID: widget.userID,
                      imagePath: getImage.getFile,
                      nickname: _nickname.text,
                      email: "",
                      phone: _phone.text,
                      birthday: "",
                      describe: _personalInfo.text,
                    ),
                  ],
                ),
              ),
            ),
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: Container(
                padding: EdgeInsets.all(20),
                height: screenSize.height,
                width: screenSize.width,
                child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Wrap(
                        runSpacing: 80,
                        children: <Widget>[
                          /* Display userprofile, selectable */
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 100,
                              width: 100,
                              alignment: Alignment.center,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(1000),
                                onTap: () {
                                  setState(() {
                                    isShownBottomAvatar = true;
                                  });
                                  showBotomSheetAvatar(context, screenSize.width, getImage);
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: getImage.isChangeAvatar == false
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            color: Colors.grey,
                                          )
                                        : widget.currentProfile != null
                                            ? loadImageNetwork(widget.currentProfile)
                                            : getImage.getFile != null
                                                ? loadImage(getImage.getFile)
                                                : loadImageNetwork(
                                                    AppConstraint.sample_proifle_url)),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Nickname"),
                                  TextFormField(
                                    focusNode: _nickNameFocus,
                                    controller: _nickname,
                                    decoration: InputDecoration(
                                      hintText: "Enter your nick name",
                                      labelStyle: TextStyle(color: Colors.white),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Personal profile"),
                                  TextFormField(
                                    focusNode: _personalInfoFocus,
                                    controller: _personalInfo,
                                    decoration: InputDecoration(
                                      hintText: "Enter your personal information",
                                      labelStyle: TextStyle(color: Colors.white),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Birthday"),
                                  TextFormField(
                                    focusNode: _birthdayFocus,
                                    controller: _birthday,
                                    readOnly: true,
                                    onTap: () {
                                      selectDay(context);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Select your birthday",
                                      labelStyle: TextStyle(color: Colors.white),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 1)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              /* Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "+84",
                                            textAlign: TextAlign.center,
                                          ))),
                                  Expanded(
                                    flex: 6,
                                    child: TextFormField(
                                      focusNode: _phoneFocus,
                                      controller: _phone,
                                      onTap: () {},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),*/
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Email"),
                                        TextFormField(
                                          focusNode: _emailFocus,
                                          controller: _email,
                                          readOnly: true,
                                          onTap: () {},
                                          decoration: InputDecoration(
                                            hintText: "Your email here",
                                            labelStyle: TextStyle(color: Colors.white),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: Colors.white, width: 1)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      )),
                ),
              ),
            ));
      },
    );
  }
}

showBotomSheetAvatar(BuildContext context, double width, ChangeProfile getImage) {
  ImagePicker imagePicker = ImagePicker();
  return showModalBottomSheet(
      backgroundColor: Colors.white,
      useRootNavigator: true,
      enableDrag: true,
      context: context,
      builder: (context) => Container(
          width: width,
          height: 50,
          child: FlatButton(
              onPressed: () async {
                var image = await imagePicker.getImage(source: ImageSource.gallery);
                //close modal
                Navigator.pop(context);
                //print(image);
                try {
                  getImage.setFilePath(File(image.path));
                } catch (e) {}
              },
              child: Text(
                "Change Avatar",
                style: TextStyle(color: Colors.black),
              ))));
}
