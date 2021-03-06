import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/view/dashboard/categories_detail/categories_detail.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class GameGenre extends StatefulWidget {
  final String genre;
  final String token;
  GameGenre({this.genre, this.token});
  @override
  _GameGenreState createState() => _GameGenreState();
}

class _GameGenreState extends State<GameGenre> {
  GraphQLQuery _query = GraphQLQuery();

  /*Future<List<Game>> getGameByGenre() async {
    GraphQLClient client = config.clientToQueryMongo();
    try {
      var result = await client.query(QueryOptions(
          documentNode: gql(_query.getGameByGenres(widget.genre))));
      print("Game genre ${result.data}") ;
      List<Game> game = ListGame.fromJson(result.data).games;
      return game;
    } catch (e) {
      return [];
    }
  }*/

  @override
  void initState() {
    //getGameByGenre();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleIcon(
                      icon: FeatherIcons.arrowLeft,
                      iconSize: 20,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.genre,
                      style: TextStyle(fontSize: AppConstraint.genre_title_action),
                    )
                  ],
                ),
                Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(icon: Icon(Icons.search), onPressed: () {})),
              ],
            ),
            preferredSize: Size.fromHeight(AppConstraint.appBarHeight)),
        body: GraphQLProvider(
          client: customClient(widget.token),
          child: CacheProvider(
            child: Container(
                padding: EdgeInsets.all(10),
                child: Query(
                  options: QueryOptions(documentNode: gql(_query.getGameByGenres(widget.genre))),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.loading) {
                      return Align(
                          alignment: Alignment.center,
                          child: AppConstraint.spinKitCubeGrid(context));
                    }
                    if (result.hasException || result.data == null) {
                      AnimatedContainer(
                          duration: Duration(seconds: 10),
                          curve: Curves.bounceInOut,
                          alignment: Alignment.center,
                          child: SvgPicture.asset("assets/icons/empty_icon.svg"));
                    } else {
                      var listGame = ListGame.fromJson(result.data['getGameByGenre']).games;
                      return ListView.separated(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 30,
                              ),
                          itemCount: listGame.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(AppConstraint.container_border_radius),
                              elevation: 2,
                              child: InkWell(
                                onTap: () {
                                  Get.to(CategoriesDetail(
                                    itemTag: listGame[index].name,
                                    gameDetail: listGame[index],
                                  ));
                                },
                                child: ContainerResponsive(
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstraint.container_border_radius),
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Color(0xff2b5876), Color(0xff4e4376)]),
                                    ),
                                    width: screenSize.width,
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          left: 20,
                                          top: -20,
                                          child: CachedNetworkImage(
                                            imageUrl: listGame[index].coverImage,
                                            placeholder: (context, url) {
                                              return Container(color: Colors.blueGrey);
                                            },
                                            imageBuilder: (context, url) {
                                              return ContainerResponsive(
                                                alignment: Alignment.center,
                                                height: 100.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      image: url,
                                                      fit: BoxFit.cover,
                                                    )),
                                              );
                                            },
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 120,
                                          top: 20,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              TextResponsive(
                                                listGame[index].name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: checkBrightness(context)
                                                        ? Colors.black
                                                        : Colors.white),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Wrap(
                                                runAlignment: WrapAlignment.start,
                                                runSpacing: 10,
                                                direction: Axis.horizontal,
                                                children: <Widget>[
                                                  getIconPlatforms(listGame[index].platforms)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: Text("Empty"),
                    );
                  },
                )),
          ),
        ));
  }
}

Widget getIconPlatforms(List<dynamic> list) {
  List<SvgPicture> listIcon = List<SvgPicture>();
  myDefineSvgIcon(String uri) {
    return SvgPicture.asset(
      uri,
      height: 18,
      width: 18,
    );
  }

  for (var item in list) {
    switch (item) {
      case 'Windows':
        listIcon.add(myDefineSvgIcon('assets/icons/platforms/windows-white.svg'));
        continue;
      case 'PS4':
        listIcon.add(myDefineSvgIcon('assets/icons/platforms/playstation-white.svg'));
        continue;
      case 'Xbox':
        listIcon.add(myDefineSvgIcon(
          'assets/icons/platforms/xbox-white.svg',
        ));
        continue;
      case 'Xbox One':
        listIcon.add(myDefineSvgIcon(
          'assets/icons/platforms/xbox-white.svg',
        ));
        continue;
      case 'Nintendo':
        listIcon.add(myDefineSvgIcon(
          'assets/icons/platforms/nintendo-switch-white.svg',
        ));
        continue;
      case 'Nintendo Switch':
        listIcon.add(myDefineSvgIcon(
          'assets/icons/platforms/nintendo-switch-white.svg',
        ));
        continue;
      case 'Nintendo 3DS':
        listIcon.add(myDefineSvgIcon('assets/icons/platforms/nintendo-switch-white.svg'));
        continue;
      case 'Android':
        listIcon.add(myDefineSvgIcon(
          'assets/icons/platforms/android-white.svg',
        ));
        continue;
      case 'iOS':
        listIcon.add(myDefineSvgIcon(
          'assets/icons/platforms/apple-white.svg',
        ));
        continue;
      default:
        return null;
    }
  }
  /*list.forEach((element) {
      print("Hello $element");
  });*/
  return Wrap(
    spacing: 5,
    children: listIcon,
  );
}
