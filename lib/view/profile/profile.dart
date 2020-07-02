import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/profile/custom/changeLanguage.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:gamming_community/view/profile/profileController.dart';
import 'package:gamming_community/view/profile/row_account_setting.dart';
import 'package:get/get.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  final String userID, userProfile, userName;
  Profile({this.userID, this.userProfile, this.userName});

  @override
  Widget build(BuildContext context) {
    
    bool isEng = Get.find<SharedPreferences>().getBool("isEng");
    return GetBuilder<ProfileController>(
      init: ProfileController(),
        builder: (p) => Scaffold(
              appBar: CustomAppBar(
                  child: [
                    Spacer(),
                    RaisedButton.icon(
                        onPressed: () {
                          Get.to(EditProfile(userID: userID, currentProfile: userProfile),
                              opaque: false, transition: Transition.leftToRightWithFade);
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        icon: Icon(Icons.wb_iridescent),
                        label: Text("Edit")),
                  ],
                  height: 50,
                  onNavigateOut: () {
                    Get.back();
                  },
                  padding: EdgeInsets.only(right: 10),
                  backIcon: FeatherIcons.arrowLeft),
              body: ContainerResponsive(
                  width: Get.width,
                  child: Column(
                    children: <Widget>[
                      //Edit button
                      Expanded(
                          flex: 2,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              // profile image
                              Positioned.fill(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration: Duration(seconds: 1),
                                      imageBuilder: (context, imageProvider) => ContainerResponsive(
                                        height: 100.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1000),
                                            border: Border.all(
                                                width: 0.5, color: AppColors.BACKGROUND_COLOR),
                                            image: DecorationImage(
                                                fit: BoxFit.cover, image: imageProvider)),
                                      ),
                                      imageUrl: userProfile == ""
                                          ? AppConstraint.sample_proifle_url
                                          : userProfile,
                                      placeholder: (context, url) => ContainerResponsive(
                                        height: 100.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(1000)),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                    SizedBoxResponsive(
                                      height: 20,
                                    ),
                                    TextResponsive(
                                      userName,
                                    ),
                                    TextResponsive(
                                      "@name",
                                    ),
                                    /*Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleIcon(
                                        icon: FeatherIcons.userPlus,
                                        iconSize: 25,
                                        onTap: () {},
                                      ),
                                      CircleIcon(
                                        icon: FeatherIcons.messageCircle,
                                        iconSize: 25,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),*/
                                  ],
                                ),
                              ),
                            ],
                          )),
                      // Setting blablabla....

                      Expanded(
                        flex: 3,
                        child: Padding(
                            padding: EdgeInsetsResponsive.symmetric(horizontal: 0, vertical: 10),
                            child: Wrap(
                              runSpacing: 15,
                              spacing: 20,
                              children: <Widget>[
                                RowProfileSetting(
                                  icon: OpenIconicIcons.sun,
                                  clickable: false,
                                  onTap: () {},
                                  text: "Dark mode",
                                  widget: GetX<ProfileController>(
                                    builder: (value) => Switch(
                                      value: value.darkTheme.value,
                                      onChanged: (e) {
                                        p.setTheme(e);
                                      }),
                                  )
                                ),
                                RowProfileSetting(
                                    onTap: () {},
                                    widget: Row(
                                      children: <Widget>[
                                        //default language here
                                        ChangeLanguage(
                                          defaultLanguage: isEng ? "en" : "vi",
                                        )
                                      ],
                                    ),
                                    clickable: false,
                                    icon: Icons.language, //  color: Colors.amber,
                                    text: "Language"),
                                RowProfileSetting(
                                    onTap: () {},
                                    widget: Container(
                                      padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                      child: Text("0"),
                                    ),
                                    icon: Icons.leak_add, //color: Colors.blueGrey,
                                    text: "Follows"),
                                RowProfileSetting(
                                    onTap: () {},
                                    widget: Container(
                                      padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                      child: Text("0"),
                                    ),
                                    icon: Icons.favorite, //  color: Colors.pink
                                    text: "Following"),
                                RowProfileSetting(
                                    onTap: () {},
                                    widget: Container(
                                      padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                      child: Text("0"),
                                    ),
                                    icon: Icons.feedback,
                                    text: "Feedback"),
                                RowProfileSetting(
                                    onTap: () async {
                                      print("log out");

                                      await p.loggout();
                                    },
                                    widget: Container(),
                                    icon: Icons.power_settings_new, //color: Colors.red[300]
                                    text: "Log out")
                              ],
                            )),
                      )
                    ],
                  )),
            ));
  }
}

/*class Profile extends StatefulWidget {
  final String userID, userProfile, userName;
  Profile({this.userID, this.userProfile, this.userName});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final username = "NOTHING", nickName = "@ callMyName";
  final backgroundColor = Color(0xff322E2E);
  final usernameStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final nickNameStyle = TextStyle(fontWeight: FontWeight.w200);
  bool changeTheme = false;
  SettingProvider settingProvider;

  Future getInfo() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    bool isEng = refs.getBool("isEng") == null ? true : false;
    return isEng;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    settingProvider = Injector.get();
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
          child: [
            Spacer(),
            RaisedButton.icon(
                onPressed: () {
                  Get.to(EditProfile(userID: widget.userID, currentProfile: widget.userProfile),
                      opaque: false, transition: Transition.leftToRightWithFade);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                icon: Icon(Icons.wb_iridescent),
                label: Text("Edit")),
          ],
          height: 50,
          onNavigateOut: () {
            Get.back();
          },
          padding: EdgeInsets.only(right: 10),
          backIcon: FeatherIcons.arrowLeft),
      body: ContainerResponsive(
          width: Get.width,
          child: FutureBuilder(
            future: getInfo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                    alignment: Alignment.center, child: AppConstraint.loadingIndicator(context));
              } else {
                bool isEng = snapshot.data;
                return Column(
                  children: <Widget>[
                    //Edit button
                    Expanded(
                        flex: 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            // profile image
                            Positioned.fill(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration: Duration(seconds: 1),
                                    imageBuilder: (context, imageProvider) => ContainerResponsive(
                                      height: 100.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1000),
                                          border: Border.all(
                                              width: 0.5, color: AppColors.BACKGROUND_COLOR),
                                          image: DecorationImage(
                                              fit: BoxFit.cover, image: imageProvider)),
                                    ),
                                    imageUrl: widget.userProfile == ""
                                        ? AppConstraint.sample_proifle_url
                                        : widget.userProfile,
                                    placeholder: (context, url) => ContainerResponsive(
                                      height: 100.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(1000)),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  SizedBoxResponsive(
                                    height: 20,
                                  ),
                                  TextResponsive(
                                    widget.userName ?? username,
                                    style: usernameStyle,
                                  ),
                                  TextResponsive(
                                    nickName,
                                    style: nickNameStyle,
                                  ),
                                  /*Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircleIcon(
                                        icon: FeatherIcons.userPlus,
                                        iconSize: 25,
                                        onTap: () {},
                                      ),
                                      CircleIcon(
                                        icon: FeatherIcons.messageCircle,
                                        iconSize: 25,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        )),
                    // Setting blablabla....

                    Expanded(
                      flex: 3,
                      child: Padding(
                          padding: EdgeInsetsResponsive.symmetric(horizontal: 0, vertical: 10),
                          child: Wrap(
                            runSpacing: 15,
                            spacing: 20,
                            children: <Widget>[
                              RowProfileSetting(
                                icon: OpenIconicIcons.sun,
                                clickable: false,
                                onTap: () {},
                                text: "Dark mode",
                                widget: Switch(
                                    value: changeTheme,
                                    onChanged: (e) {
                                      settingProvider.setTheme();
                                      setState(() {
                                        changeTheme = e;
                                      });
                                    }),
                              ),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Row(
                                    children: <Widget>[
                                      //default language here
                                      ChangeLanguage(
                                        defaultLanguage: isEng ? "en" : "vi",
                                      )
                                    ],
                                  ),
                                  clickable: false,
                                  icon: Icons.language, //  color: Colors.amber,
                                  text: "Language"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icons.leak_add, //color: Colors.blueGrey,
                                  text: "Follows"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icons.favorite, //  color: Colors.pink
                                  text: "Following"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icons.feedback,
                                  text: "Feedback"),
                              RowProfileSetting(
                                  onTap: () async {
                                    print("log out");
                                    await loggout(context);
                                  },
                                  widget: Container(),
                                  icon: Icons.power_settings_new, //color: Colors.red[300]
                                  text: "Log out")
                            ],
                          )),
                    )
                  ],
                );
              }
            },
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future loggout(BuildContext context) async {
  SharedPreferences ref = await SharedPreferences.getInstance();

  return Get.defaultDialog(
    title: "Log out",
    middleText: "Are you sure you want to log out?",
    actions: [
      FlatButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Cancel")),
      RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () async {
            await ref.setBool('isLogin', false);
            Get.offAllNamed(
              '/',
              predicate: (route) => false,
            );
          },
          child: Text("Log Out")),
    ],
  );

  //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
}
*/
