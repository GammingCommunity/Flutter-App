import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class AddConservation extends StatefulWidget {
  @override
  _AddConservationsState createState() => _AddConservationsState();
}

class _AddConservationsState extends State<AddConservation> {
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
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          ContainerResponsive(
            height: 50.h,
            margin: EdgeInsetsResponsive.only(bottom: 20),
            width: screenSize.width,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 5,
                  child: InkWell(
                    child: Text("Cancel", style: TextStyle(color: Colors.indigo, fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  "New Conservation",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30),
              height: 50,
              width: screenSize.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("To:"),
                  ),
                  Expanded(
                    child: TextFormField(
                        decoration: InputDecoration.collapsed(
                      hintText: "Type a name or phone number",
                      border: InputBorder.none,
                    )),
                  )
                ],
              )),
          //List friends here
          //TODO add check friend
          Expanded(
              child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsetsResponsive.all(10.0),
                    child: Text("RECENTLY CONTACT"),
                  )),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemCount: sampleUser.length,
                  itemBuilder: (context, index) {
                    return buildItem(sampleUser[index]);
                  },
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}

Widget buildItem(String profileUrl) {
  return Container(
    height: 60.h,
    width: ScreenUtil().uiWidthPx,
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.all(5),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10000),
              child: CachedNetworkImage(height: 50, width: 50, imageUrl: profileUrl)),
        ),
        Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Sample name",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Same describle")
              ],
            ))
      ],
    ),
  );
}
