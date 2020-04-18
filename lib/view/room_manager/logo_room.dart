import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LogoRoom extends StatefulWidget {
  final String url;
  LogoRoom({this.url});
  @override
  _LogoRoomState createState() => _LogoRoomState();
}

class _LogoRoomState extends State<LogoRoom> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      imageBuilder: (context, imageProvider) {
        return Container(
          alignment: Alignment.center,
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo, width: 2),
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              )),
        );
      },
      placeholder: (context, url) => Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
