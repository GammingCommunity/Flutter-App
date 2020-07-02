import 'package:flutter/material.dart';
import 'package:gamming_community/view/game_genre/game_genre.dart';
import 'package:get/get.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Map<String, String>> _listGenre = [
    {"genre": "Action", "image": "assets/categories/Action.png"},
    {"genre": "Massive \nMutiplayer", "image": "assets/categories/Massive Multiplayer.png"},
    {"genre": "Singleplayer", "image": "assets/categories/Singleplayer.png"},
    {"genre": "Indie", "image": "assets/categories/Indie.png"},
    {"genre": "Horror", "image": "assets/categories/Horror.png"},
    {"genre": "RPG", "image": "assets/categories/RPG.png"},
    {"genre": "Strategy", "image": "assets/categories/Strategy.png"},
    {"genre": "Shooter", "image": "assets/categories/Shooter.png"},
    {"genre": "Sport", "image": "assets/categories/Sport.png"},
    {"genre": "Fighting", "image": "assets/categories/Fighting.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
      padding: EdgeInsetsResponsive.symmetric(vertical: 10),
      height: 200.h,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
          itemCount: _listGenre.length,
          itemBuilder: (context, index) {
            return Material(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(15),
              elevation: 3,
              child: InkWell(
                onTap: () {
                  Get.to(
                      GameGenre(
                        genre: _listGenre[index].values.toList()[0],
                      ),
                      transition: Transition.upToDown);
                },
                child: ContainerResponsive(
                  alignment: Alignment.center,
                  width: 120.w,
                  decoration: BoxDecoration(
                      /*gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xff29323c), Color(0xff485563)]),*/
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(Colors.grey[200], BlendMode.softLight),
                          fit: BoxFit.cover,
                          image: AssetImage(_listGenre[index].values.toList()[1]))),
                  child: TextResponsive(
                    _listGenre[index].values.toList()[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        shadows: [Shadow(blurRadius: 1, color: Colors.black, offset: Offset(1, 2))],
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
