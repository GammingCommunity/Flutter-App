import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/urlPreview.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/utils/display_image.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/utils/generatePalate.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:get/get.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

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
                  child: messageType == MessageEnum.image
                      ? InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            generatePalete(context, text.content, false, messageType);
                          },
                          child: Container(
                            // show image by 50%
                            height: text.fileInfo.height.toDouble() * 0.5,
                            width: text.fileInfo.width.toDouble() * 0.5,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: text.content,
                              height: text.fileInfo.height.toDouble(),
                              width: text.fileInfo.width.toDouble(),
                              placeholder: (context, url) => Container(
                                height: text.fileInfo.height.toDouble(),
                                width: text.fileInfo.width.toDouble(),
                                decoration: BoxDecoration(
                                    color: Colors.grey, borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ),
                        )
                      : messageType == MessageEnum.text
                          ? Container(
                              //alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).primaryColor,
                              ),
                              child:
                                  Text(text.content, style: Theme.of(context).textTheme.bodyText2),
                            )
                          : messageType == MessageEnum.file
                              ? buildFileMessage("FILE")
                              : messageType == MessageEnum.gif
                                  ?
                                  //loadGif,
                                  Container()
                                  : // load url metadata
                                  UrlPreview(
                                      url: text.content,
                                    )),
            ],
          ),
        ) //new
        );
  }
}

Widget buildFileMessage(String name) {
  double messageHeight = 55;
  return Container(
    height: messageHeight,
    width: 150,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), color: Color(AppColors.SEARCH_BACKGROUND)),
    child: Stack(
      children: [
        Positioned(
            left: 0,
            child: Container(
                width: 50,
                height: messageHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    color: Colors.indigo),
                child: Icon(FeatherIcons.file))),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: Text(name),
        ))
      ],
    ),
  );
}
