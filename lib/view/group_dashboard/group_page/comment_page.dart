import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:get/get.dart';

class CommentPage extends StatefulWidget {
  final String poster;
  final String commentID;

  const CommentPage({this.poster, this.commentID});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: PreferredSize(
            child: Row(
              children: [
                CircleIcon(
                    icon: FeatherIcons.arrowLeft,
                    onTap: () {
                      Get.back();
                    }),
                Text(widget.poster)
              ],
            ),
            preferredSize: Size.fromHeight(40)),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Text("Load comment here"),
        ),
      ),
    );
  }
}
