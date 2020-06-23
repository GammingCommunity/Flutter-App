import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamming_community/class/ImageContent.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PostProvider extends StatesRebuilder {
  int page = 0;
  var postContent = <PostContent>[];
  var images = <File>[];
  var video = [];
  List<File> imagesGalery = [];
  int get postCotentLength => postContent.length;
  List<File> get getImageGalery => imagesGalery;

  Future getAllImages([int page = 0]) async {
    /* Map<dynamic, dynamic> object = await _channel.invokeMethod('getAllImages');
    return object;*/
    List<AssetPathEntity> list =
        await PhotoManager.getAssetPathList(type: RequestType.image, hasAll: false);
    for (var path in list) {
      var list = await path.getAssetListPaged(page, 10);
      list.forEach((item) async {
        imagesGalery.add(await item.file);
      });
    }

    return imagesGalery;
  }

  Future initImageGalery() async {
    return await getAllImages();
  }

  Future loadMoreImage() async {
    page++;
    print(page);
    return await getAllImages(this.page);
  }

  void selectImage(File file) {
    this.images.add(file);
    rebuildStates();
  }

  void removeFromPostContent(int index) {
    this.postContent.removeAt(index);
    rebuildStates();
  }

  Future addAllChooseImage() async {
    for (var item in images) {
      var decodedImage = await decodeImageFromList(item.readAsBytesSync());

      this.postContent.add(PostContent(
          file: item,
          height: decodedImage.height,
          width: decodedImage.width,
          postType: PostType.image));
    }
    images = [];
    rebuildStates();
  }

  void clear() {
    page = 0;
    images = [];
    video = [];
    postContent.clear();
  }
}
