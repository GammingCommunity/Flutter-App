import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/list_game_image.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  Config config = Config();
  GraphQLQuery _query = GraphQLQuery();
  /*Future<List<String>> getImage() async {
    List<String> _image = [];
    GraphQLClient client = config.clientToQueryMongo();
    try {
      var result = await client
          .query(QueryOptions(documentNode: gql(_query.getListGame(1))));
      for (var item in result.data.values.first) {
        _image.add(item["image"][0]);
      }
      setState(() {
        _image = _image;
      });
      return _image;
    } catch (e) {
      return _image;
    }
  }*/
  //TODO:  add blurhash, implement later
  @override
  void initState() {
    //getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return GraphQLProvider(
      client: config.client,
      child: CacheProvider(
          child: Query(
        options: QueryOptions(documentNode: gql(_query.getListGame(1))),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return ClipRRect(borderRadius: BorderRadius.circular(15),child: Image.asset('assets/images/no_image.png',fit: BoxFit.cover));
          }
          if (result.loading) {
            return Shimmer.fromColors(
                
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(height: 150),
                ),
                baseColor: Colors.grey[400],
                highlightColor: Colors.grey);
          } else {
            var _image = ListGameImage.fromJson(result.data['getListGame']).listGameImage;

            return _image.isEmpty
                ? Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/icons/empty_icon.svg'))
                : CarouselSlider.builder(
                    height: 150,
                    itemCount: 3,
                    itemBuilder: (context, indexItem) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          height: 200,
                          width: screenSize.width,
                          child: CachedNetworkImage(
                              filterQuality: FilterQuality.medium,
                              fit: BoxFit.cover,
                              imageUrl: _image[indexItem].imageUrl[0],
                              placeholder: (context, index) {
                                return SpinKitCubeGrid(size: 20, color: Colors.white);
                              },
                              errorWidget: (context, url, error) => Container(
                                  alignment: Alignment.center, child: Icon(Icons.error_outline)),
                              imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )));
                    },
                    enlargeCenterPage: true,
                    /*items: values.data.map((f) {
                  return Builder(builder: (BuildContext context) {
                    return 
                  });
                }).toList(),
                height: 150,*/
                  );
          }
        },
      )),
    );
  }
}
