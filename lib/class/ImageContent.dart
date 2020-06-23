import 'dart:io';

enum PostType { image, video }

class PostContent {
  final int height;
  final int width;
  final File file;
  final PostType postType;

  PostContent({this.height, this.width, this.file, this.postType});
}
