import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final double imageBorderRadius;
  final double imageHeight, imageWidth;

  const CustomImage(
      {@required this.url,
      @required this.imageBorderRadius,
      @required this.imageHeight,
      @required this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeInCurve: Curves.easeIn,
      fadeInDuration: Duration(seconds: 1),
      imageBuilder: (context, imageProvider) => Container(
        height: imageHeight,
        width: imageWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(imageBorderRadius),
            border: Border.all(width: 0.5, color: AppColors.BACKGROUND_COLOR),
            image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
      ),
      imageUrl: url,
      placeholder: (context, url) => Container(
        height: imageHeight,
        width: imageWidth,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(imageBorderRadius)),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
