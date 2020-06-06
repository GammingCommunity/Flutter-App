import 'package:flutter/material.dart';

class PrivateMessage extends StatelessWidget {
  final String currentID;
  final Map<String, dynamic> sender;
  final String text;
  final AnimationController animationController;
  final DateTime sendDate;
  PrivateMessage({this.currentID, this.text, this.animationController, this.sender, this.sendDate});
  @override
  Widget build(BuildContext context) {
    //ThemeModel themeModel = Injector.get(context: context);
    // bool isMe = themeModel.sender == sender;
    //print(sender['id']);
    bool isMe = currentID == sender['id'];

    return SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut), //new
        axisAlignment: 0.0,
        axis: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                InkWell(
                  borderRadius: BorderRadius.circular(1000),
                  
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(sender['profile_url']),
                  ),
                ),
              Flexible(
                child: Container(
                  //alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(text, style: Theme.of(context).textTheme.bodyText2),
                ),
              ),
              if (isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/300"),
                ),
            ],
          ),
        ) //new
        );
  }
}
