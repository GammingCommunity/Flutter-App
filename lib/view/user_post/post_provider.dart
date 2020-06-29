import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gamming_community/API/PostMutation.dart';
import 'package:gamming_community/API/PostQuery.dart';
import 'package:gamming_community/class/ImageContent.dart';
import 'package:gamming_community/class/Post.dart';
import 'package:gamming_community/repository/file_upload_repo.dart';
import 'package:gamming_community/repository/post_repo.dart';
import 'package:gamming_community/utils/enum/postEnum.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class PostProvider extends StatesRebuilder {
  int page = 0;
  var postContent = <PostContent>[];
  var tags = <String>[];
  var images = <File>[];
  var video = [];
  var query = PostQueryGraphQL();
  var mutation = PostMutateGraphQL();

  List<File> imagesGalery = [];
  int get postCotentLength => postContent.length;
  List<File> get getImageGalery => imagesGalery;
  bool get isImagesChoose => images.length > 0;

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

  void selectImage(int index, File file) {
    this.images.insert(index, file);
    rebuildStates();
  }

  void deselectImage(int index) {
    this.images.removeAt(index);
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
    images.clear();
    rebuildStates();
  }

  Future addPickImage(File file) async {
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    this.postContent.add(PostContent(
        file: file,
        height: decodedImage.height,
        width: decodedImage.width,
        postType: PostType.image));
  }

  Future<Post> post(String content) async {
    List medias = await FileUploadRepo.getMediaUpload(postContent);
    var result = await PostRepo.mutationGraphQL(
        await getToken(),
        mutation.createPost(
            "", content, json.encode(medias), [], PostPermission.public));
    var postId = result.data['createPost']['payload'];
    clear();
    return Post(
        content: content,
        countComment: 0,
        countReaction: 0,
        createdTime: DateTime.now().toLocal(),
        media: medias,
        permission: PostPermission.public,
        postId: postId,
        tag: [],
        title: "");
  }

  void clear() {
    page = 0;
    images = [];
    video = [];
    imagesGalery.clear();
    postContent.clear();
  }
}
