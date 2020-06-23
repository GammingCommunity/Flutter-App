import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/utils/display_image.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

Future generatePalete(
    BuildContext context, String content, bool fromStorage, String messageType) async {
  //check imagePath is uri or url
  var decodedImage;
  PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      fromStorage == true
          ? AssetImage(content)
          : CachedNetworkImageProvider(messageType == "media" ? content : ""),
      size: Size(110, 150),
      maximumColorCount: 30);
  if (fromStorage) {
    var decodedImage = await decodeImageFromList(File(content).readAsBytesSync());
    Get.to(
    DisplayImage(
        imageUrl: fromStorage == true ? content : content,
        imageHeight: decodedImage.height,
        imageWidth: decodedImage.width,
        fromStorage: fromStorage,
        palate: paletteGenerator),
    transition: Transition.fade,
  );
  }
  
  
}
