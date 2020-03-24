import 'package:flutter/material.dart';
import 'package:gamming_community/API/config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SelectGame extends StatefulWidget {
  @override
  _SelectGameState createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> with TickerProviderStateMixin {
  double height = 50;
  Config config = Config();
  var searchGameController = TextEditingController();
  var searchGameFocus = FocusNode();
  AnimationController controller;
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return GraphQLProvider(
      client: config.client,
      child: CacheProvider(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              heroTag: "selectGame", onPressed: () {}, child: Icon(Icons.chevron_right)),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){
              print("tap outside");
              setState(() {
                height= 50;
                FocusScope.of(context).requestFocus(new FocusNode());
              });
            },
            child: Container(
              padding: EdgeInsets.all(20),
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    // Use the properties stored in the State class.
                    height: height,
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Color(0xff5a5757),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                      width: screenSize.width - 40,
                      padding: EdgeInsets.only(left:10,right: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                      child: TextField(

                        onTap: () {
                          setState(() {
                            height = 300;
                          });
                        },
                        enableSuggestions: true,

                        decoration: InputDecoration.collapsed(
                          
                            hintText: "Search your game here",
                            fillColor: Color(0xff5a5757),
                            filled: true),
                        controller: searchGameController,
                      ),
                    ),
                  ),
                  /*AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) {
                      return Transform.scale(scale: 0.5, child: child);
                    },
                    child: Container(
                      height: 100,
                      width: 200,
                    ),
                  )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
