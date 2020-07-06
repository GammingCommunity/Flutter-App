import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/Conservation.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/customWidget/urlPreview.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/utils/enum/messageEnum.dart';
import 'package:gamming_community/utils/generatePalate.dart';
import 'package:gamming_community/utils/skeleton_template.dart';

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
                    onTap: () {},
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                            ),
                        imageUrl: friend.profileUrl)),
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
                                color: brighten(Colors.black, 10),
                              ),
                              child:
                                  Text(text.content, style: Theme.of(context).textTheme.bodyText2),
                            )
                          : messageType == MessageEnum.file
                              ? buildFileMessage(text.fileInfo)
                              : messageType == MessageEnum.gif
                                  ?
                                  //loadGif,
                                  CachedNetworkImage(
                                      placeholder: (context, url) => SkeletonTemplate.image(
                                          text.fileInfo.height.toDouble() * 0.5,
                                          text.fileInfo.width.toDouble() * 0.5,
                                          15),
                                      imageBuilder: (context, imageProvider) => Container(
                                            height: text.fileInfo.height.toDouble() * 0.5,
                                            width: text.fileInfo.width.toDouble() * 0.5,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                image: DecorationImage(image: imageProvider)),
                                          ),
                                      imageUrl: text.content)
                                  : // load url metadata
                                  UrlPreview(url: text.content)),
            ],
          ),
        ) //new
        );
  }
}

Widget buildFileMessage(FileInfo file) {
  double messageHeight = 60;
  return Container(
    height: messageHeight,
    width: 200,
    alignment: Alignment.center,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(15), color: brighten(Colors.black, 10)),
    child: Row(
      children: [
        Container(
            width: 50,
            height: messageHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                color: Colors.indigo),
            child: Icon(FeatherIcons.file)),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(file.fileName), Text(file.fileSize)],
        ),
        SizedBox(width: 10),
        Icon(Icons.file_download)
      ],
    ),
  );
}
