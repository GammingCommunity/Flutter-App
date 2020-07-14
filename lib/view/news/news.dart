// paginate
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/class/News.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:gamming_community/utils/timeAgo.dart';
import 'package:gamming_community/view/news/provider/newsProvider.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class NewsWidget extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<NewsWidget> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: Get.height,
            width: Get.width,
            child: WhenRebuilderOr<NewsProvider>(
              initState: (context,model ) => model.setState((s) => s.init()),
                observe: () => RM.get<NewsProvider>(),
                onWaiting: () => AppConstraint.loadingIndicator(context),
                builder: (context, model) => ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    padding: EdgeInsetsResponsive.symmetric(horizontal: 10, vertical: 10),
                    itemCount: model.state.news.length,
                    itemBuilder: (context, index) {
                      var news = model.state.news;
                      return buildItem(news[index]);
                    }))));
  }
}

Widget buildItem(News news) {
  return Container(
    height: 100,
    width: Get.width,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
    child: Row(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                news.shortText,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Row(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        getImageSource(news.source),
                        height: 30,
                        width: 30,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Text("${getTime(time: news.time)}")
                ],
              )
            ],
          ),
        )),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: news.imageUrl,
            height: 100,
            width: 100,
            placeholder: (context, url) => SkeletonTemplate.image(100, 100, 15),
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  );
}

String getImageSource(String source) {
  switch (source) {
    case "videoGamer":
      return "assets/icons/article_logo/pc_gamer.png";
    case "gameRadar":
      return "assets/icons/article_logo/game_radar.png";
    case "gameSpot":
      return "assets/icons/article_logo/game_spot.png";
    default:
      return "";
  }
}
