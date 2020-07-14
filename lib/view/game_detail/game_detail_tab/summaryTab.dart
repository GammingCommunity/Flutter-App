import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customImage.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/view/game_detail/provider/game_detail_provider.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SummaryTab extends StatefulWidget {
  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  @override
  Widget build(BuildContext context) {
    return StateBuilder<GameDetailProvider>(
      observe: () => RM.get<GameDetailProvider>(),
      builder: (context, model) {
        var game = model.state.game;
        return Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: <Widget>[
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomImage(
                        url: game.logo, imageBorderRadius: 15, imageHeight: 100, imageWidth: 100),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            game.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Container(
                              height: 50,
                              width: Get.width,
                              child: ListView.builder(
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var rawData = [
                                      "No tag",
                                      "No tag",
                                      "No tag",
                                      "No tag",
                                      "No tag"
                                    ];
                                    return Chip(label: Text(rawData[index]));
                                  }))
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              // game summary
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: brighten(Colors.black, 10),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        game.summary,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.fade,
                        maxLines: model.state.descTextShowFlag ? 20 : 8,
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Flexible(
                          child: InkWell(
                            onTap: () => model.setState((s) => s.showTextMore()),
                            child: model.state.descTextShowFlag
                                ? Container(
                                    height: 30,
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.indigo),
                                    child: Text("Show less"))
                                : Container(
                                    height: 30,
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.indigo),
                                    child: Text("Show more")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // this for screenshot slider
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 200,
                ),
                itemCount: game.images.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: Get.width,
                      height: 200,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: CustomImage(
                        url: game.images[index],
                        imageBorderRadius: 15,
                        imageHeight: 200,
                        imageWidth: Get.width,
                      ));
                },
              )
            ],
          ),
        );
      },
    );
  }
}
