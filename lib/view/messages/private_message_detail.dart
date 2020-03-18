import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';

class PrivateMessages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<PrivateMessages>
    with AutomaticKeepAliveClientMixin<PrivateMessages> {
  String roomName = "Sample here";
  bool isSubmited = false;
  final chatController = TextEditingController();
  List<String> sampleUser = [
    "https://api.adorable.io/avatars/90/abott@adorable.io.png",
    "https://api.adorable.io/avatars/90/magic.png",
    "https://api.adorable.io/avatars/90/closer.png",
    "https://api.adorable.io/avatars/90/mygf.png",
    "https://api.adorable.io/avatars/90/yolo.pngCopy.png",
    "https://api.adorable.io/avatars/90/facebook.png",
    "https://api.adorable.io/avatars/90/dump.png",
    "https://api.adorable.io/avatars/90/pikachu.png",
    "https://api.adorable.io/avatars/90/lumber.png",
    "https://api.adorable.io/avatars/90/wing.png"
  ];
  Future getImage() async {
    return sampleUser;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(color: Colors.white),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$roomName',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    Positioned(
                        right: 5,
                        child: Material(
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.call),
                                onPressed: () {
                                  callGroup(context, getImage());
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.group),
                                onPressed: () {},
                                color: Colors.black,
                              )
                            ],
                          ),
                        ))
                  ],
                )),
            SizedBox(height: 10),
            Flexible(
                child: Container(
              color: Colors.blue,
            )),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white70,
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {
                        print('Attach');
                      },
                      color: Colors.black),
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            isSubmited = true;
                          });
                        },
                        controller: chatController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Text here')),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Future callGroup(BuildContext context, Future getImage) {
  return showModalBottomSheet(
      context: context,
      builder: (bottomSheetBuilder) => Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: AppColors.BACKGROUND_COLOR),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Invite to call',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text('Select user')
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {},
                  )
                ],
              ),
              Expanded(
                  flex: 1,
                  child: FutureBuilder(
                      future: getImage,
                      initialData: [],
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else
                          return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    thickness: 1,
                                  ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10000.0),
                                            child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              imageUrl: snapshot.data[index],
                                              fadeInDuration:
                                                  Duration(seconds: 3),
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Hummmmmmmmm",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        Stack(
                                          alignment: Alignment.centerRight,
                                          children: <Widget>[
                                            Positioned(
                                                child: SizedBox(
                                              width: 60,
                                              child: RaisedButton(
                                                  onPressed: () {},
                                                  child: Text("Add")),
                                            ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                      }))
            ],
          )));
}
