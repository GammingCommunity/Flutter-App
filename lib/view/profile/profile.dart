import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/profile/custom/changeLanguage.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:gamming_community/view/profile/row_account_setting.dart';
import 'package:gamming_community/view/profile/settingProvider.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Profile extends StatefulWidget {
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
  final borderRadius = BorderRadius.circular(15);
  bool changeTheme = false;
  SettingProvider settingProvider;

  Future getInfo() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    List<String> res = refs.getStringList("userToken");
    //print(res[0]);
    print('profile ${widget.userProfile}');
    return res;
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    settingProvider = Injector.get(context: context);
    super.build(context);
    return Scaffold(
      body: ContainerResponsive(
          width: ScreenUtil.screenWidth,
          child: FutureBuilder(
            future: getInfo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                    alignment: Alignment.center, child: AppConstraint.spinKitCubeGrid(context));
              } else
                return Column(
                  children: <Widget>[
                    //Edit button
                    Expanded(
                        flex: 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Positioned.fill(
                                child: Padding(
                              padding: EdgeInsetsResponsive.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleIcon(
                                        icon: FeatherIcons.chevronLeft,
                                        iconSize: 25,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      )),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsetsResponsive.only(right: 10),
                                      child: RaisedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).push(PageRouteBuilder(
                                                pageBuilder: (context, a1, a2) => EditProfile(
                                                    userID: widget.userID,
                                                    currentProfile: widget.userProfile),
                                                transitionsBuilder: (context, anim, a2, child) {
                                                  // slide from bottom to top
                                                  var begin = Offset(0.0, 1.0);
                                                  var end = Offset.zero;
                                                  var curve = Curves.ease;
                                                  var tween = Tween(begin: begin, end: end)
                                                      .chain(CurveTween(curve: curve));
                                                  return SlideTransition(
                                                      child: child, position: anim.drive(tween));
                                                }));
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: borderRadius),
                                          icon: Icon(Icons.wb_iridescent),
                                          label: Text("Edit")),
                                    ),
                                  )
                                ],
                              ),
                            )),
                            // profile image
                            Positioned.fill(
                              top: 50.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration: Duration(seconds: 1),
                                    imageBuilder: (context, imageProvider) => ContainerResponsive(
                                      height: 80.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(1000),
                                          image: DecorationImage(
                                              fit: BoxFit.cover, image: imageProvider)),
                                    ),
                                    imageUrl: widget.userProfile == null
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
                                  Row(
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    // Setting blablabla....

                    Expanded(
                      flex: 3,
                      child: Padding(
                          padding: EdgeInsetsResponsive.symmetric(horizontal: 10, vertical: 10),
                          child: Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            children: <Widget>[
                              RowProfileSetting(
                                icon: Icon(
                                  OpenIconicIcons.moon,
                                  size: 30,
                                ),
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
                                        defaultLanguage: "en",
                                      )
                                    ],
                                  ),
                                  clickable: false,
                                  icon: Icon(Icons.language, size: 30, color: Colors.amber),
                                  text: "Language"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icon(Icons.leak_add, size: 30, color: Colors.blueGrey),
                                  text: "Follows"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icon(Icons.favorite, size: 30, color: Colors.pink),
                                  text: "Following"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icon(
                                    Icons.feedback,
                                    size: 30,
                                  ),
                                  text: "Feedback"),
                              RowProfileSetting(
                                  onTap: () {},
                                  widget: Container(
                                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                                    child: Text("0"),
                                  ),
                                  icon: Icon(Icons.leak_remove, size: 30, color: Colors.red[300]),
                                  text: "Restrict users"),
                              RowProfileSetting(
                                  onTap: () async {
                                    print("log out");
                                    loggout(context);
                                  },
                                  widget: Container(),
                                  icon: Icon(Icons.power_settings_new,
                                      size: 30, color: Colors.red[300]),
                                  text: "Log out")
                            ],
                          )),
                    )
                  ],
                );
            },
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void loggout(BuildContext context) async {
  SharedPreferences ref = await SharedPreferences.getInstance();
  ref.setBool('isLogin', false);
  Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
}
