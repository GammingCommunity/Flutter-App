import 'dart:io';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';

class ImageContent extends StatefulWidget {
  final Function onRemove;
  final Function onClick;
  final File file;
  final int imageWidth;
  final int imageHeight;

  const ImageContent(
      {@required this.onClick,
      @required this.onRemove,
      this.file,
      this.imageHeight,
      this.imageWidth});

  @override
  _ImageContentState createState() => _ImageContentState();
}

class _ImageContentState extends State<ImageContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.imageHeight.toDouble() * 0.2,
      width: widget.imageWidth.toDouble() * 0.2,
      child: Stack(
        children: [
          Positioned.fill(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(widget.file, fit: BoxFit.cover))),
          Positioned(
            right:5,
            top: 5,
            child: CircleIcon(
              toolTip: "Remove image",
              icon: FeatherIcons.x,iconBackgroundColor: Colors.black,iconSize: 30,onTap: () => widget.onRemove()),
          ),
        ],
      ),
    );
  }
}
