import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/display_image.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class GroupChatMessage extends StatefulWidget {
  final bool fromLocal;

  final http.StreamedResponse progress;
  final String type;
  final String currentID;
  final Map<String, dynamic> sender;
  final String text;
  final String imageUrl;
  final AnimationController animationController;
  final DateTime sendDate;
  GroupChatMessage(
      {this.type,
      this.imageUrl,
      this.currentID,
      this.text,
      this.animationController,
      this.sender,
      this.sendDate,
      this.progress,
      this.fromLocal});

  @override
  _GroupChatMessageState createState() => _GroupChatMessageState();
}

class _GroupChatMessageState extends State<GroupChatMessage> {
  int total = 0, _received = 0;
  bool uploadComplete = false;
  Future showProgress() async {
    widget.progress.stream.listen((value) {
      print(value);
      setState(() {
        _received += value.length;
      });
      print(_received);
    }).onDone(() {
      setState(() {
        uploadComplete = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showProgress();
  }

  @override
  Widget build(BuildContext context) {
    //ThemeModel themeModel = Injector.get(context: context);
    // bool isMe = themeModel.sender == sender;
    //print(sender['id']);
    bool isMe = widget.currentID == widget.sender['id'];
    bool fromLocal = widget.fromLocal;
    print("type here ${widget.type}");
    return SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: widget.animationController, curve: Curves.easeOut), //new
        axisAlignment: 0.0,
        axis: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                InkWell(
                  onTap: () {
                    print("profile");
                  },
                  borderRadius: BorderRadius.circular(1000),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.sender['profile_url']),
                  ),
                ),
              if (isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/300"),
                ),
              if (widget.type == "text")
                Flexible(
                  child: Container(
                      //alignment: Alignment.center,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(widget.text, style: Theme.of(context).textTheme.bodyText2)),
                ),
              if (widget.type == "media")
                Flexible(
                    child: Container(
                  color: Colors.grey,
                  margin: EdgeInsets.only(left: 10),
                  height: 100,
                  width: 200,
                  child: Stack(
                    children: <Widget>[
                      fromLocal == true
                          ? Align(
                              alignment: Alignment.center,
                              child: Image.file(
                                File(widget.imageUrl),
                                height: 100,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : InkWell(
                            onTap: (){
                              print("image click ${widget.imageUrl}");
                              //Navigator.of(context).push(PageTransition(child: DisplayImage(imageUrl: widget.imageUrl,), type: PageTransitionType.scale));
                            },
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.network(
                                  widget.imageUrl,
                                  height: 100,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Align(
                        alignment: Alignment.center,
                        child: uploadComplete
                            ? Container()
                            : CircularProgressIndicator(
                                backgroundColor: Colors.amber,
                                value: _received.toDouble(),
                              ),
                      )
                    ],
                  ),
                ))
            ],
          ),
        ) //new
        );
  }
}
