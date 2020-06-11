import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/skeleton_template.dart';
import 'package:get/get.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

class UrlPreview extends StatefulWidget {
  final String url;
  UrlPreview({this.url});
  @override
  _UrlPreviewState createState() => _UrlPreviewState();
}

class _UrlPreviewState extends State<UrlPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            return SizedBox(
              height: 50,
              width: 50,
              child: Align(alignment: Alignment.center, child: CircularProgressIndicator()),
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
                                    topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
                          ),
                      errorWidget: (context, url, error) =>
                          Container(height: Get.height, width: 100, color: Colors.grey),
                      placeholder: (context, url) =>
                          Container(height: Get.height, width: 100, color: Colors.grey),
                      imageUrl: info.image),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            info.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Flexible(child: Text(info.description)),
                        Flexible(
                          child: Text(
                            info.url,
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
    );
  }
}
