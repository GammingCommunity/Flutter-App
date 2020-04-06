import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/dashboard/carousel.dart';
import 'package:gamming_community/view/dashboard/categories/categories.dart';
import 'news/News.dart';

class DashBoard extends StatefulWidget {
  final String token;
  DashBoard({this.token});
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with AutomaticKeepAliveClientMixin<DashBoard> {
  @override
  void initState() {
    //print('init state');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    super.build(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Carousel(widget.token)),
            SizedBox(height: 10),
            Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Category",
                        style: TextStyle(fontSize: AppConstraint.categoryText)),
                    Material(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      type: MaterialType.circle,
                        child: IconButton(
                            icon: Icon(Icons.expand_more), onPressed: () {}))
                  ],
                )),
            SizedBox(height: 10),
            Category(),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("News",
                    style: TextStyle(fontSize: AppConstraint.categoryText)),
                Divider(),
              ],
            ),
            News(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
