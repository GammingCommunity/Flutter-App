import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/class/Game.dart';
import 'package:gamming_community/provider/search_game.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/view/room/room_selector/select_num_member.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:open_iconic_flutter/open_iconic_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

final _animateList = GlobalKey<AnimatedListState>();
class SelectGame extends StatefulWidget {

  @override
  _SelectGameState createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> with TickerProviderStateMixin {
  double height = 50;
  var searchGameController = TextEditingController();
  var searchGameFocus = FocusNode();
  AnimationController controller;
  bool clearText = false;
  int numofMember = 2;
  int currentIndex = 0;
  double opacity = 0;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    searchGameController.dispose();
    super.dispose();
  }

  double changeHeight(int number) {
    return (120 * number).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var searchGame = Provider.of<SearchGame>(context);
    return GraphQLProvider(
      // TODO: provider get token from sharedprefrence
        client: customClient(""),
        child: CacheProvider(
            child: Selector<SearchGame, Tuple5<bool, bool, int, int, List<Game>>>(
          selector: (_, value) => Tuple5(value.isSearch, value.isHideSearch, value.listQuery.length,
              value.listLength, value.games),
          builder: (context, value, child) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                  heroTag: "selectGame",
                  onPressed: () {
                    
                  },
                  child: Icon(Icons.chevron_right)),
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print("tap outside");
                  setState(() {
                    searchGame.hideSearchResult(false);

                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: screenSize.height,
                    width: screenSize.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60,
                          alignment: Alignment.centerLeft,
                          child: Text("CHOOSE YOUR GAME",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: <Widget>[
                            AnimatedContainer(
                              // Use the properties stored in the State class.
                              height: value.item2
                                  ? (value.item3 != 0 ? changeHeight(value.item3) : 50)
                                  : height,
                              width: screenSize.width,
                              decoration: BoxDecoration(
                                color: Color(AppConstraint.searchBackground),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              duration: Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn,
                              // display data here
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                padding: EdgeInsets.only(left: 10, right: 10),
                                height: 80,
                                width: screenSize.width - 40,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: value.item3,
                                  itemBuilder: (context, index) {
                                    print("hummm ${value.item4}");
                                    return value.item4 < 0
                                        ? Container(
                                            color: Colors.red,
                                            alignment: Alignment.center,
                                            height: 50,
                                            width: screenSize.width - 40,
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text("No values"))
                                        : Material(
                                            color: Color(AppConstraint.searchBackground),
                                            child: InkWell(
                                              onTap: () {
                                                searchGame.selectGame(index);
                                                setState(() {
                                                  searchGameController.clear();
                                                  clearText = false;
                                                });
                                              },
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child: CachedNetworkImage(
                                                      imageUrl: searchGame.listQuery[index].logo,
                                                      fit: BoxFit.cover,
                                                      height: 50,
                                                      width: 50,
                                                      imageBuilder: (context, imageProvider) {
                                                        return Container(
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey[400],
                                                              image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.contain),
                                                              borderRadius:
                                                                  BorderRadius.circular(15)),
                                                        );
                                                      },
                                                      placeholder: (context, url) => Container(
                                                        height: 50,
                                                        width: 50,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey[400],
                                                            borderRadius:
                                                                BorderRadius.circular(15)),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(searchGame.listQuery[index].name ?? "Null")
                                                ],
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              width: screenSize.width - 40,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                              child: TextField(
                                onTap: () {
                                  searchGame.hideSearchResult(true);
                                },
                                onSubmitted: (String value) {
                                  print("your query $value");
                                  if (value.trim() == "") {
                                    return;
                                  } else
                                    searchGame.requestGetGame(value);
                                  // expaned

                                  searchGame.expand();
                                },
                                onChanged: (value) {
                                  if (value.trim().length == 0) {
                                    setState(() {
                                      clearText = false;
                                    });
                                  } else
                                    setState(() {
                                      clearText = true;
                                    });
                                },
                                enableSuggestions: true,
                                decoration: InputDecoration(
                                    prefixIconConstraints: BoxConstraints(
                                      minHeight: 32,
                                      minWidth: 32,
                                    ),
                                    contentPadding: EdgeInsets.only(top: 12),
                                    icon: Icon(Icons.search, color: Colors.white),
                                    border: InputBorder.none,
                                    hintText: "Search your game here",
                                    fillColor: Color(AppConstraint.searchBackground),
                                    filled: true,
                                    suffixIcon: Padding(
                                        padding: EdgeInsets.all(0.0),
                                        child: Stack(
                                          fit: StackFit.loose,
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Visibility(
                                                  visible: value.item1,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                  ),
                                                )),
                                            // clear button
                                            Visibility(
                                              visible: clearText,
                                              child: Material(
                                                  clipBehavior: Clip.antiAlias,
                                                  color: Colors.transparent,
                                                  type: MaterialType.circle,
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.clear,
                                                      size: 15,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        clearText = false;
                                                      });
                                                      searchGameController.clear();
                                                      searchGame.clearListSearch();
                                                      searchGame.hideSearchResult(true);
                                                    },
                                                  )),
                                            )
                                          ],
                                        ))),
                                controller: searchGameController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        // show game in list here
                        Container(
                          height: 300,
                          width: screenSize.width,
                          alignment: Alignment.center,
                          child: value.item5.length <= 0
                              ? Text("Please choose one games")
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        //color:Colors.amber,
                                        width: screenSize.width - 40,
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Stack(
                                              overflow: Overflow.visible,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                      height: 150,
                                                      width: 150,
                                                      fit: BoxFit.cover,
                                                      imageUrl: value.item5[index].logo),
                                                ),
                                                Positioned(
                                                    top: -10,
                                                    right: -10,
                                                    child: Material(
                                                      type: MaterialType.circle,
                                                      clipBehavior: Clip.antiAlias,
                                                      color: Colors.transparent,
                                                      child: IconButton(
                                                          icon: Icon(OpenIconicIcons.circleX),
                                                          onPressed: () {
                                                            searchGame.removeGame();
                                                          }),
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              value.item5[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 20),
                                            )
                                          ],
                                        ));
                                  },
                                ),
                        ),
                        // number of member

                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: <Widget>[
                              Text("Select your number of member :",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Container(
                                  alignment: Alignment.topLeft,
                                  height: 100,
                                  width: screenSize.width - 40,
                                  child: SelectNumOfMember(
                                    defaultPosition: currentIndex,
                                    selectedPosition: (int value) {
                                      setState(() {
                                        currentIndex = value;
                                      });
                                    },
                                    listWidget: 3,
                                    selectedValue: (int value) {
                                      print(value);
                                    },
                                    values: ["2", "4", "6"],
                                  ))
                            ],
                          ),
                        ),
                        Text("Or type here"),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Color(AppConstraint.searchBackground),
                              borderRadius: BorderRadius.circular(15)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true, signed: false),
                            decoration: InputDecoration.collapsed(
                              hintText: "",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )));
  }
}
