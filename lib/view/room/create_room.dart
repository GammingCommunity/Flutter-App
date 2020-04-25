import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';

class CreateRoom extends StatefulWidget {
  final String userID,gameID;
  CreateRoom({this.userID,this.gameID});

  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  bool _isPublic = true;
  bool isScroll = false;
  List<String> sampleUser = [
    "https://api.adorable.io/avatars/90/abott@adorable.io.png",
    "https://api.adorable.io/avatars/90/magic.png",
    "https://api.adorable.io/avatars/90/closer.png",
    "https://api.adorable.io/avatars/90/mygf.png",
    "https://api.adorable.io/avatars/90/yolo.pngCopy.png",
  ];
  Future getImage() async {
    return sampleUser;
  }

  @override
  void initState() {
    super.initState();
  }

  setScrollPhysics(bool b) {
    return b ? NeverScrollableScrollPhysics() : ScrollPhysics();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
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
          physics: isScroll
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          child: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.insert_photo),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Group name",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 15)),
                        TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                          onTap: () {
                            print("on tap");
                            setState(() {
                              isScroll = true;
                            });
                          },
                          onEditingComplete: () {},
                          onSubmitted: (e) {
                            SystemChannels.textInput.invokeMethod('TextInput.hide');
                            setState(() {
                              isScroll = false;
                            });
                          },
                          decoration: InputDecoration(
                              hintText: "Type your group name",
                              border: InputBorder.none),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    width: screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.public,
                            size: 40,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Make Public Room",
                                style: TextStyle(fontSize: 20)),
                            Text(
                                "Anyone with the link can join or invited by host",
                                style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        Switch(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: _isPublic,
                          onChanged: (bool newValue) {
                            print(newValue);
                            setState(() {
                              _isPublic = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Invited People",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 15)),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: FutureBuilder(
                          future: getImage(),
                          initialData: [],
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(10),
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 20,
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      for (var item in snapshot.data)
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10000.0),
                                          onTap: () {},
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10000.0),
                                              child: CachedNetworkImage(
                                                height: 60,
                                                width: 60,
                                                imageUrl: item,
                                                fadeInDuration:
                                                    Duration(seconds: 3),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              )),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    )),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppConstraint.button_radius)),
                          onPressed: () {
                            
                          },
                          child: Text("CREATE ROOM"),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
