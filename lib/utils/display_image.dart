import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String imageUrl;
  DisplayImage({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Container(child: BackdropFilter(filter: ImageFilter.blur()))),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenSize.width,
                    height: 200,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Container(
                        width: screenSize.width,
                        height: 200,
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
