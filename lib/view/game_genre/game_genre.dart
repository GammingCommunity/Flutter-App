import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GameGenre extends StatefulWidget {
  final String genre;
  GameGenre({this.genre});
  @override
  _GameGenreState createState() => _GameGenreState();
}

class _GameGenreState extends State<GameGenre> {
  Config config = Config();
  final _query = GraphQLQuery();
  

  Future<List<Game>> getGameByGenre() async {
    GraphQLClient client = config.clientToQueryMongo();
    try {
      var result = await client.query(QueryOptions(
          documentNode: gql(_query.getGameByGenres(widget.genre))));
      List<Game> game = ListGame.fromJson(result.data.data).games;
      return game;
    } catch (e) {
      return [];
    }
  }

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
                    Material(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(20),
                        child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })),
                    SizedBox(width: 10),
                    Text(
                      widget.genre,
                      style:
                          TextStyle(fontSize: AppConstraint.genre_title_action),
                    )
                  ],
                ),
                Material(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(20),
                    child:
                        IconButton(icon: Icon(Icons.search), onPressed: () {})),
              ],
            ),
            preferredSize: Size.fromHeight(AppConstraint.appBarHeight)),
        body: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: getGameByGenre(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Align(
                    alignment: Alignment.center,
                    child: SpinKitCubeGrid(
                      color: Colors.white,
                      size: 20,
                    ),
                  );
                  break;

                case ConnectionState.done:
                  if (snapshot.data.isEmpty || snapshot.hasError) {
                    print(snapshot.data);
                    return  AnimatedContainer(
                      duration: Duration(seconds: 10),
                      curve: Curves.bounceInOut,
                        alignment: Alignment.center,
                          child:
                              SvgPicture.asset("assets/icons/empty_icon.svg")
                    );
                  } else
                    return ListView.separated(
                        padding: EdgeInsets.only(
                            top: 20, left: 10, right: 10, bottom: 10),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 30,
                            ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    AppConstraint.container_border_radius),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff2b5876),
                                      Color(0xff4e4376)
                                    ]),
                              ),
                              width: screenSize.width,
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Positioned(
                                    left: 20,
                                    top: -20,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data[index].coverImage,
                                      placeholder: (context, url) {
                                        return Align(
                                            alignment: Alignment.center,
                                            child: SpinKitFadingCube(
                                              color: Colors.white,
                                              size: 20,
                                            ));
                                      },
                                      imageBuilder: (context, url) {
                                        return Container(
                                          alignment: Alignment.center,
                                          height: 100,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: url,
                                                fit: BoxFit.cover,
                                              )),
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 120,
                                    top: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          runAlignment: WrapAlignment.start,
                                          runSpacing: 10,
                                          direction: Axis.horizontal,
                                          children: <Widget>[
                                            getIconPlatforms(
                                                snapshot.data[index].platforms)
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ));
                        });
                  break;

                default:
                  return Container(
                    alignment: Alignment.center,
                    child: Text("Empty"),
                  );
              }
            },
          ),
        ));
  }
}

Widget getIconPlatforms(List<String> list) {
  List<SvgPicture> listIcon = List<SvgPicture>();
  for (var item in list) {
    switch (item) {
      case 'Windows':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/windows-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'PS4':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/playstation-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'Xbox':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/xbox-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'Xbox One':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/xbox-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'Nintendo':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/nintendo-switch-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'Nintendo Switch':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/nintendo-switch-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'Nintendo 3DS':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/nintendo-switch-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'Android':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/android-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      case 'iOS':
        listIcon.add(SvgPicture.asset(
          'assets/icons/platforms/apple-white.svg',
          height: 15,
          width: 15,
        ));
        continue;
      default:
        return null;
    }
  }
  return Wrap(
    spacing: 5,
    children: listIcon,
  );
}
