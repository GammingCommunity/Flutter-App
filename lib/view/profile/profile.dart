<<<<<<< HEAD
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:gamming_community/view/profile/row_account_setting.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final username = "NOTHING", nickName = "@ callMyName";
  final backgroundColor = Color(0xff322E2E);
  final usernameStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  final nickNameStyle = TextStyle(fontWeight: FontWeight.w200);

  final borderRadius = BorderRadius.circular(15);
  bool changeTheme = false;
  // List<bool> _isSelected = List.generate(3, (_) => false);

  Future getInfo() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    List<String> res = refs.getStringList("userToken");
    //print(res[0]);
    return res;
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: screenSize.width,
          color: AppColors.BACKGROUND_COLOR,
          child: FutureBuilder(
            future: getInfo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  alignment: Alignment.center,
                  child: SpinKitCubeGrid(
                    color: Colors.white,
                    size: 20,
                  ),
                );
              } else
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Positioned(
                                width: MediaQuery.of(context).size.width,
                                left: 0,
                                top: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: RaisedButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder:
                                                          (context, a1, a2) =>
                                                              EditProfile(
                                                                token: snapshot
                                                                    .data[2],
                                                              ),
                                                      transitionsBuilder:
                                                          (context, anim, a2,
                                                              child) {
                                                        // slide from bottom to top
                                                        var begin =
                                                            Offset(0.0, 1.0);
                                                        var end = Offset.zero;
                                                        var curve = Curves.ease;
                                                        var tween = Tween(
                                                                begin: begin,
                                                                end: end)
                                                            .chain(CurveTween(
                                                                curve: curve));
                                                        return SlideTransition(
                                                            child: child,
                                                            position: anim
                                                                .drive(tween));
                                                      }));
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: borderRadius),
                                            icon: Icon(Icons.wb_iridescent),
                                            label: Text("Edit")),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  CachedNetworkImage(
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration: Duration(seconds: 2),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          image: DecorationImage(
                                              image: imageProvider)),
                                    ),
                                    imageUrl: AppConstraint.sample_proifle_url,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(1000)),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data != null
                                        ? snapshot.data[0]
                                        : username,
                                    style: usernameStyle,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    nickName,
                                    style: nickNameStyle,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        type: MaterialType.circle,
                                        child: IconButton(
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.person_add,
                                              size: 25,
                                            ),
                                            onPressed: () {}),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        type: MaterialType.circle,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.message,
                                              size: 25,
                                            ),
                                            onPressed: () {}),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                OpenIconicIcons.moon,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "Dark mode",
                                                style: settingFont,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                            value: changeTheme,
                                            onChanged: (e) {
                                              setState(() {
                                                changeTheme = e;
                                              });
                                            })
                                      ],
                                    ),
                                    /* ToggleButtons(children: [
                                  FlatButton(
                                      onPressed: () {},
                                      child: Text("Use system preference")),
                                  FlatButton(
                                      onPressed: () {},
                                      child: Text("Dark Mode")),
                                  FlatButton(
                                      onPressed: () {},
                                      child: Text("Light Mode")),
                                ], isSelected: _isSelected)*/
                                  ],
                                ),
                                InkWell(
                                    onTap: () {},
                                    child: rowAccountSetting(
                                        Icon(Icons.language,
                                            size: 30, color: Colors.amber),
                                        "Language")),
                                rowAccountSetting(
                                    Icon(Icons.leak_add,
                                        size: 30, color: Colors.blueGrey),
                                    "Follows"),
                                rowAccountSetting(
                                    Icon(Icons.favorite,
                                        size: 30, color: Colors.pink),
                                    "Following"),
                                rowAccountSetting(
                                    Icon(
                                      Icons.feedback,
                                      size: 30,
                                    ),
                                    "Feedback"),
                                rowAccountSetting(
                                    Icon(Icons.leak_remove,
                                        size: 30, color: Colors.red[300]),
                                    "Restrict users"),
                                InkWell(
                                    onTap: () {},
                                    child: rowAccountSetting(
                                        Icon(Icons.power_settings_new,
                                            size: 30, color: Colors.red[300]),
                                        "Log out"))
                              ],
                            )),
                      ),
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
=======
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/profile/edit_profile.dart';
import 'package:gamming_community/view/profile/row_account_setting.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with AutomaticKeepAliveClientMixin {
  final username = "NOTHING", nickName = "@ callMyName";
  final backgroundColor = Color(0xff322E2E);
  final usernameStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  final nickNameStyle = TextStyle(fontWeight: FontWeight.w200);

  final borderRadius = BorderRadius.circular(15);
  bool changeTheme = false;
  // List<bool> _isSelected = List.generate(3, (_) => false);

  Future getInfo() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    List<String> res = refs.getStringList("userToken");
    //print(res[0]);
    return res;
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: screenSize.width,
          color: AppColors.BACKGROUND_COLOR,
          child: FutureBuilder(
            future: getInfo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  alignment: Alignment.center,
                  child: SpinKitCubeGrid(
                    color: Colors.white,
                    size: 20,
                  ),
                );
              } else
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Positioned(
                                width: MediaQuery.of(context).size.width,
                                left: 0,
                                top: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: RaisedButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder:
                                                          (context, a1, a2) =>
                                                              EditProfile(
                                                                token: snapshot
                                                                    .data[2],
                                                              ),
                                                      transitionsBuilder:
                                                          (context, anim, a2,
                                                              child) {
                                                        // slide from bottom to top
                                                        var begin =
                                                            Offset(0.0, 1.0);
                                                        var end = Offset.zero;
                                                        var curve = Curves.ease;
                                                        var tween = Tween(
                                                                begin: begin,
                                                                end: end)
                                                            .chain(CurveTween(
                                                                curve: curve));
                                                        return SlideTransition(
                                                            child: child,
                                                            position: anim
                                                                .drive(tween));
                                                      }));
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: borderRadius),
                                            icon: Icon(Icons.wb_iridescent),
                                            label: Text("Edit")),
                                      )
                                    ],
                                  ),
                                )),
                            Positioned(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  CachedNetworkImage(
                                    fadeInCurve: Curves.easeIn,
                                    fadeInDuration: Duration(seconds: 2),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          image: DecorationImage(
                                              image: imageProvider)),
                                    ),
                                    imageUrl: AppConstraint.sample_proifle_url,
                                    placeholder: (context, url) => Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(1000)),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data != null
                                        ? snapshot.data[0]
                                        : username,
                                    style: usernameStyle,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    nickName,
                                    style: nickNameStyle,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        type: MaterialType.circle,
                                        child: IconButton(
                                            padding: EdgeInsets.all(0),
                                            icon: Icon(
                                              Icons.person_add,
                                              size: 25,
                                            ),
                                            onPressed: () {}),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        clipBehavior: Clip.antiAlias,
                                        type: MaterialType.circle,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.message,
                                              size: 25,
                                            ),
                                            onPressed: () {}),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Expanded(
                      flex: 3,
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                OpenIconicIcons.moon,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "Dark mode",
                                                style: settingFont,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Switch(
                                            value: changeTheme,
                                            onChanged: (e) {
                                              setState(() {
                                                changeTheme = e;
                                              });
                                            })
                                      ],
                                    ),
                                    /* ToggleButtons(children: [
                                  FlatButton(
                                      onPressed: () {},
                                      child: Text("Use system preference")),
                                  FlatButton(
                                      onPressed: () {},
                                      child: Text("Dark Mode")),
                                  FlatButton(
                                      onPressed: () {},
                                      child: Text("Light Mode")),
                                ], isSelected: _isSelected)*/
                                  ],
                                ),
                                InkWell(
                                    onTap: () {},
                                    child: rowAccountSetting(
                                        Icon(Icons.language,
                                            size: 30, color: Colors.amber),
                                        "Language")),
                                rowAccountSetting(
                                    Icon(Icons.leak_add,
                                        size: 30, color: Colors.blueGrey),
                                    "Follows"),
                                rowAccountSetting(
                                    Icon(Icons.favorite,
                                        size: 30, color: Colors.pink),
                                    "Following"),
                                rowAccountSetting(
                                    Icon(
                                      Icons.feedback,
                                      size: 30,
                                    ),
                                    "Feedback"),
                                rowAccountSetting(
                                    Icon(Icons.leak_remove,
                                        size: 30, color: Colors.red[300]),
                                    "Restrict users"),
                                InkWell(
                                    onTap: () {},
                                    child: rowAccountSetting(
                                        Icon(Icons.power_settings_new,
                                            size: 30, color: Colors.red[300]),
                                        "Log out"))
                              ],
                            )),
                      ),
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
>>>>>>> 18325bbeee3512d61d0afa5b5d870b5a902264ca
