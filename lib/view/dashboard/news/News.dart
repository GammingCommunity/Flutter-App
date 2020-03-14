import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/News.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  GraphQLQuery query = GraphQLQuery();
  Config config = Config();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GraphQLProvider(
      client: config.client,
      child: CacheProvider(
          child: Container(
        height: screenSize.height,
        child: Query(
          options: QueryOptions(
              variables: {"page": 1, "limit": 5},
              documentNode: gql(query.getNews("pcgamer"))),
          builder: (result, {fetchMore, refetch}) {
            if (result.loading) {
              return Shimmer.fromColors(
                child: Container(
                  height: 200,
                  width: screenSize.width,
                  child: Text("data"),
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
              );
            }
            if (result.hasException) {
              return Align(alignment: Alignment.center, child: Text("No news"));
            } else {
              var listNews =
                  ListNews.fromJson(result.data['fetchNews']).listNews;
              return Align(
                alignment: Alignment.topCenter,
                child: CarouselSlider.builder(
                    viewportFraction: 1.2,
                    height: 300,
                    itemCount: listNews.length,
                    itemBuilder: (context, i) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        width: screenSize.width,
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                                height: 200,
                                width: screenSize.width,
                                fit: BoxFit.cover,
                                imageUrl: listNews[i].imageUrl),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/icons/article_logo/pc_gamer.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                              width: screenSize.width - 80,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Flexible(
                                                      child: Text(
                                                    listNews[i].shortText,
                                                    
                                                    style: TextStyle(
                                                      
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                                ],
                                              )),
                                          Text("${listNews[1].time} days ago")
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
