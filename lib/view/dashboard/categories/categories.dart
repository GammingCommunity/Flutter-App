import 'package:flutter/material.dart';
import 'package:gamming_community/view/game_genre/game_genre.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<String> _listGenre = [
    "Action",
    "Massively Mutiplayer",
    "Singleplayer",
    "Indie",
    "Horror",
    "RPG",
    "Strategy",
    "Shooter",
    "Sport",
    "Fighting"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          LimitedBox(
            maxHeight: 100,
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
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return GameGenre(genre: _listGenre.elementAt(index),);
                        }));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xff29323c), Color(0xff485563)]),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.amber),
                        child: Text(
                          _listGenre.elementAt(index),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
