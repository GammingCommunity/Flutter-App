import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/dashboard/categories/categories.dart';
import 'package:gamming_community/view/dashboard/high_light_game.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'news/News.dart';

class DashBoard extends StatefulWidget {
  final String token;
  DashBoard({this.token});
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with AutomaticKeepAliveClientMixin<DashBoard> {
  @override
  void initState() {
    //print('init state');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ContainerResponsive(
      padding: EdgeInsetsResponsive.all(10),
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
                height: 200.h,
                width: MediaQuery.of(context).size.width,
                child: Carousel(widget.token)),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Category", style: TextStyle(fontSize: AppConstraint.categoryText)),
              
            ],
          ),
          SizedBox(height: 10),
          Flexible(
            flex: 2,
            child: Category()),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("News", style: TextStyle(fontSize: AppConstraint.categoryText)),
              Divider(),
            ],
          ),
          Flexible(
            flex: 4,
            child: News()),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
