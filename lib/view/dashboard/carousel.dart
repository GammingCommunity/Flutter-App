import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  Config config = Config();
  GraphQLQuery _query = GraphQLQuery();
  List<String> _image = [];
  Future<List<String>> getImage() async {
    
    GraphQLClient client = config.clientToQueryMongo();
    try {
      var result = await client
          .query(QueryOptions(documentNode: gql(_query.getListGame(1))));
      for (var item in result.data.values.first) {
        _image.add(item["image"][0]);
      }

      return _image;
    } catch (e) {
      return _image;
    }
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return /*FutureBuilder<List<String>>(
        future: getImage(),
        builder: (context, AsyncSnapshot<List<String>> values) {
          switch (values.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
              break;
            default:
              return 
          }
        });*/
        CarouselSlider.builder(
      height: 150,
      itemCount: 3,
      itemBuilder: (context, indexItem) {
        if(_image.isEmpty) return SpinKitCubeGrid(size: 20,color:Colors.white);
        else return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            height: 150,
            width: screenSize.width,
            child: CachedNetworkImage(
              filterQuality: FilterQuality.medium,
                fit: BoxFit.cover,
                imageUrl: _image.elementAt(indexItem),

                placeholder: (context, index) {
                  return SpinKitCubeGrid(size:20,color:Colors.white);
                },

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
}
String random( List<String> s){
  Random ran= Random();
  List<String> newList=[];

  var newVal=  s[ran.nextInt(3)];
}