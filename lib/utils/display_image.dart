import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

class DisplayImage extends StatelessWidget {
  final String imageUrl;
  final bool fromStorage;
  final PaletteGenerator palate;
  DisplayImage({this.imageUrl, this.fromStorage = true, this.palate});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: Stack(
              children: <Widget>[
                Container(
                  color:palate.lightMutedColor.color,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: screenSize.width,
                    height: screenSize.height/3,
                    child: fromStorage
                        ? Image.file(File(imageUrl), height: 200, width: screenSize.width,fit: BoxFit.cover,)
                        : OptimizedCacheImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl,
                            placeholder: (context, url) => Container(
                              width: screenSize.width,
                              height: 200,
                            ),
                          ),
                  ),
                ),
                
              ],
            )));
  }
}
