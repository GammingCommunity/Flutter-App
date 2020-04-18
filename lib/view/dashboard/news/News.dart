import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/News.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  var query = GraphQLQuery();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GraphQLProvider(
      client: customClient(""),
      child: CacheProvider(
          child: ContainerResponsive(
        child: Query(
          options: QueryOptions(
              variables: {"page": 1, "limit": 5}, documentNode: gql(query.getNews("pcgamer"))),
          builder: (result, {fetchMore, refetch}) {
            if (result.loading) {
              return loadingHolder();
            }
            if (result.hasException) {
              return Align(alignment: Alignment.center, child: Text("No news"));
            } else {
              var listNews = ListNews.fromJson(result.data['fetchNews']).listNews;
              return Align(
                alignment: Alignment.topCenter,
                child: CarouselSlider.builder(
                    viewportFraction: 1.2,
                    height: 250.h,
                    itemCount: listNews.length,
                    itemBuilder: (context, i) {
                      return ContainerResponsive(
                        padding: EdgeInsets.all(10),
                        width: screenSize.width,
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                  height: 150.h,
                                  width: screenSize.width,
                                  fit: BoxFit.cover,
                                  imageUrl: listNews[i].imageUrl,
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/images/no_image.png', fit: BoxFit.cover)),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsetsResponsive.symmetric(horizontal: 10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          'assets/icons/article_logo/pc_gamer.png',
                                          height: 50.h,
                                          width: 50.w,
                                        ),
                                      ),
                                      SizedBoxResponsive(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          ContainerResponsive(
                                            width: ScreenUtil().uiWidthPx - 100,
                                            child: TextResponsive(
                                              """${listNews[i].shortText}""",
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          SizedBoxResponsive(width: 10),
                                          TextResponsive("${listNews[1].time} days ago")
                                        ],
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      );
                    }),
              );
            }
          },
        ),
      )),
    );
  }
}

Widget loadingHolder() {
  return ContainerResponsive(
    margin: EdgeInsetsResponsive.only(top: 10),
    width: ScreenUtil().uiWidthPx,
    child: Column(
      children: <Widget>[
        SkeletonTemplate.image(150.h, ScreenUtil().uiWidthPx, 10, Colors.grey),
        Padding(
          padding: EdgeInsetsResponsive.symmetric(vertical: 10),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // logo article
                  SkeletonTemplate.image(50, 50, 15, Colors.grey),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // title
                      SkeletonTemplate.text(20, ScreenUtil().uiWidthPx - 100, 15, Colors.grey),
                      SizedBox(height: 10),
                      // time
                      SkeletonTemplate.text(20, 40, 15, Colors.grey)
                    ],
                  )
                ],
              )),
        )
      ],
    ),
  );
}
