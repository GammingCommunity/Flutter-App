import 'dart:io';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/view/user_post/post_provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ImageHover extends StatefulWidget {
  final File file;
  final double imageSize;
  final Function onClick;
  final Function onLongPress;
  const ImageHover(
      {@required this.file, this.imageSize, @required this.onClick, @required this.onLongPress});

  @override
  _ImageHoverState createState() => _ImageHoverState();
}

class _ImageHoverState extends State<ImageHover>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  Animation animation;
  AnimationController animationController;
  bool isLongPress = false;
  PostProvider postProvider;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    postProvider = Injector.get();
    super.build(context);
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onLongPress: () {
        // has choose image
        setState(() {
            isLongPress = !isLongPress;
            //  isLongPress = !postProvider.isImagesChoose;
          });

        return widget.onLongPress(!isLongPress && postProvider.isImagesChoose? null : widget.file);
      },
      onTap: () => widget.onClick(),
      child: Container(
          height: widget.imageSize,
          width: widget.imageSize,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Positioned.fill(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  widget.file,
                  fit: BoxFit.cover,
                ),
              )),
              AnimatedPositioned(
                  right: 5,
                  top: isLongPress ? 5 : -30,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.withOpacity(0.7)),
                      child: Icon(FeatherIcons.checkCircle)),
                  duration: Duration(milliseconds: 200))
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
