import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/GroupChat.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class RoomInfo extends StatefulWidget {
  final Future future;
  final DateTime joinTime;
  RoomInfo({this.future,this.joinTime});
  @override
  _RoomInfoState createState() => _RoomInfoState();
}

class _RoomInfoState extends State<RoomInfo> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<GroupChat>(
        future: widget.future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Row(
              children: <Widget>[
                SkeletonTemplate.image(50, 50, 1000),
                SizedBoxResponsive(width: 10),
                SkeletonTemplate.text(10, 100, 15)
              ],
            );
          } else {
            var room = snapshot.data;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: room.roomLogo,
                  imageBuilder: (context, imageProvider) => ContainerResponsive(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(image: imageProvider, fit: BoxFit.fill)),
                  ),
                ),
                SizedBoxResponsive(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(room.roomName),
                    Text("${widget.joinTime.toLocal().hour.toString()} hours ago")
                  ],
                )
              ],
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}
