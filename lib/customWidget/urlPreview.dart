import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:get/get.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlPreview extends StatefulWidget {
  final String url;
  UrlPreview({this.url});
  @override
  _UrlPreviewState createState() => _UrlPreviewState();
}

class _UrlPreviewState extends State<UrlPreview> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var url = "youtube:${widget.url}";
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print("can't load");
        }
      },
      child: Container(
        height: 100,
        width: Get.width - 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(AppColors.SEARCH_BACKGROUND),
        ),
        child: FutureBuilder(
          future: Future<Metadata>(() async {
            return extract(widget.url);
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: <Widget>[
                    SkeletonTemplate.image(100, 100, 15),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonTemplate.text(10, 50, 10),
                          SkeletonTemplate.text(10, 100, 10),
                          SkeletonTemplate.text(10, 100, 10)
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              Metadata info = snapshot.data;
              return Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                        height: Get.height,
                        width: 100,
                        imageBuilder: (context, imageProvider) => Container(
                              height: 200,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15))),
                            ),
                        errorWidget: (context, url, error) =>
                            Container(height: Get.height, width: 100, color: Colors.grey),
                        placeholder: (context, url) =>
                            Container(height: Get.height, width: 100, color: Colors.grey),
                        imageUrl: info.image ?? AppConstraint.default_logo),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              info.title ?? "Has error",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Flexible(child: Text(info.description ?? "Has error")),
                          Flexible(
                            child: Text(
                              info.url ?? "Has error",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
