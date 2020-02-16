import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Auth.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config1.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final username = "NOTHING", nickName = "@ callMyName";
  final backgroundColor = Color(0xff322E2E);
  final usernameStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  final nickNameStyle = TextStyle(fontWeight: FontWeight.w200);
  final settingFont = TextStyle(fontWeight: FontWeight.bold);
  final borderRadius = BorderRadius.circular(15);
  bool changeTheme = false;
  List<bool> _isSelected = List.generate(3, (_) => false);

  Future getInfo() async{
    GraphQLQuery query= GraphQLQuery();
    SharedPreferences refs= await SharedPreferences.getInstance();
    List<String> res= refs.getStringList("userToken");
    print(res[0]);
    GraphQLClient client1= authAPI(res[0]);
 
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Row(
            children: <Widget>[],
          )),
      body: Container(
          width: double.infinity,
          color: backgroundColor,
          child: FutureBuilder(
            future: getInfo(),
            builder: (context,AsyncSnapshot snapshot){
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Material(
                                    color: Colors.transparent,
                                    type: MaterialType.circle,
                                    clipBehavior: Clip.antiAlias,
                                    child: IconButton(
                                        icon: Icon(Icons.keyboard_arrow_left),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacementNamed('/homepage');
                                        }),
                                  ),
                                  RaisedButton.icon(
                                      onPressed: () {},
                                      shape: RoundedRectangleBorder(
                                          borderRadius: borderRadius),
                                      icon: Icon(Icons.wb_iridescent),
                                      label: Text("Edit"))
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10000.0),
                                child: CachedNetworkImage(
                                  height: 100,
                                  width: 100,
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration: Duration(seconds: 2),
                                  imageUrl: "https://via.placeholder.com/150",
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data !=null ? snapshot.data[0] :username,
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
                                      padding: const EdgeInsets.only(left: 30),
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.language,
                                            size: 30,
                                            color: Colors.amber,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Language",
                                            style: settingFont,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.leak_add,
                                          size: 30, color: Colors.blueGrey),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Follows",
                                        style: settingFont,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.favorite,
                                          size: 30, color: Colors.pink),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Following",
                                        style: settingFont,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.feedback,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Feedback",
                                        style: settingFont,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.leak_remove,
                                          size: 30, color: Colors.red[300]),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Restrict users",
                                        style: settingFont,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.power_settings_new,
                                            size: 30, color: Colors.red[300]),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Log out",
                                          style: settingFont,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
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
}
