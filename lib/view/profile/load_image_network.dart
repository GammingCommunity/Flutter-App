import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

loadImageNetwork(String url) {
  return CachedNetworkImage(
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
            color: Colors.grey,
          ),
      imageUrl: url);
}
