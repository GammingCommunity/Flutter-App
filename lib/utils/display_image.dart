import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/widgets.dart';
import 'package:palette_generator/palette_generator.dart';


class DisplayImage extends StatelessWidget {
  final String imageUrl;
  final bool fromStorage;
  final PaletteGenerator palate;
  DisplayImage({this.imageUrl, this.fromStorage = true, this.palate});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: Get.height,
            width: Get.width,
            child: Stack(
              children: <Widget>[
                Container(
                  color: palate.lightMutedColor.color,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: Get.width,
                    height: Get.height / 3,
                    child: fromStorage
                        ? Image.file(
                            File(imageUrl),
                            height: 200,
                            width: Get.width,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageUrl,
                            placeholder: (context, url) => Container(
                              width: Get.width,
                              height: 200,
                            ),
                          ),
                  ),
                ),
              ],
            )));
  }
}
