import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';

class PrivateMessage extends StatelessWidget {
  final User user, friend;
  final String sender;
  final String messageType;
  final String status;
  final TextMessage text;
  final AnimationController animationController;
  final DateTime sendDate;
  PrivateMessage(
      {this.user,
      this.friend,
      this.sender,
      this.text,
      this.messageType,
      this.status,
      this.animationController,
      this.sendDate});
  @override
  Widget build(BuildContext context) {
    //ThemeModel themeModel = Injector.get(context: context);
    // bool isMe = themeModel.sender == sender;
    //print(sender['id']);
    bool isMe = user.id.toString() == sender;

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
                    backgroundImage: NetworkImage(friend.profileUrl),
                  ),
                ),
              Flexible(
                child: messageType == "media"
                    ? InkWell(
                      borderRadius: BorderRadius.circular(15),
                        onTap: () {},
                        child: Container(
                          height: text.height.toDouble(),
                          width: text.width.toDouble(),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: text.content,
                            height: text.height.toDouble(),
                              width: text.width.toDouble(),
                            placeholder: (context, url) => Container(
                              height: text.height.toDouble(),
                              width: text.width.toDouble(),
                              decoration: BoxDecoration(
                                  color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        //alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(text.content, style: Theme.of(context).textTheme.bodyText2),
                      ),
              ),
            ],
          ),
        ) //new
        );
  }
}
