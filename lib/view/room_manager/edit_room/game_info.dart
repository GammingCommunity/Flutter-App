import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class GInfo extends StatefulWidget {
  final Future gameInfo;
  final double height;
  final double width;
  final double radius;
  GInfo({this.gameInfo, this.height, this.width, this.radius});
  @override
  _GInfoState createState() => _GInfoState();
}

class _GInfoState extends State<GInfo>{
  EditRoomProvider editProvider;
  @override
  Widget build(BuildContext context) {
    editProvider = Injector.get();
    return FutureBuilder(
      future: editProvider.gameLogo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ContainerResponsive(
            height: widget.height.h,
            width: widget.width.w,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(widget.radius)),
          );
        } else {
          return CachedNetworkImage(
              placeholder: (context, url) => Container(
                    height: widget.height,
                    width: widget.width,
                    decoration: BoxDecoration(
                        color: Colors.grey, borderRadius: BorderRadius.circular(widget.radius)),
                  ),
              imageBuilder: (context, imageProvider) => Container(
                    height: widget.height,
                    width: widget.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(widget.radius)),
                  ),
              imageUrl: snapshot.data);
        }
      },
    );
  }
}
