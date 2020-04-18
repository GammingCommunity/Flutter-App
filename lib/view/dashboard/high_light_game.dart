import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/list_game_image.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class Carousel extends StatefulWidget {
  final String token;
  Carousel(this.token);
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  GraphQLQuery _query = GraphQLQuery();

  @override
  void initState() {
    //getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: customClient(widget.token),
      child: CacheProvider(
          child: Query(
        options: QueryOptions(documentNode: gql(_query.getListGame(1))),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset('assets/images/no_image.png', fit: BoxFit.cover));
          }
          if (result.loading) {
            return CarouselSlider.builder(
              height: ScreenUtil().uiHeightPx / 4,
              itemCount: 3,
              itemBuilder: (context, indexItem) {
                return ContainerResponsive(
                  margin: EdgeInsetsResponsive.symmetric(horizontal: 5.0),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  width: ScreenUtil().uiWidthPx,
                );
              },
              enlargeCenterPage: true,
            );
          } else {
            var _image = ListGameImage.fromJson(result.data['getListGame']).listGameImage;

            return _image.isEmpty
                ? Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/icons/empty_icon.svg'))
                : CarouselSlider.builder(
                    height: ScreenUtil().uiHeightPx / 2,
                    itemCount: 3,
                    itemBuilder: (context, indexItem) {
                      return Material(
                        clipBehavior: Clip.antiAlias,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {},
                          child: ContainerResponsive(
                              margin: EdgeInsetsResponsive.symmetric(horizontal: 5.0),
                              height: ScreenUtil().setHeight(200),
                              width: ScreenUtil().uiWidthPx,
                              child: CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  fit: BoxFit.cover,
                                  imageUrl: _image[indexItem].imageUrl[0],
                                  placeholder: (context, index) {
                                    return SpinKitCubeGrid(size: 20, color: Colors.white);
                                  },
                                  errorWidget: (context, url, error) => Container(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.error_outline)),
                                  imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ))),
                        ),
                      );
                    },
                    enlargeCenterPage: true,
                  );
          }
        },
      )),
    );
  }
}
