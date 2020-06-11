class MessageEnum {
  static String text = "text";
  static String video = "video";
  static String image = "image";
  static String gif = "gif";
  static String url = "url";
  static String file = "file";
}

bool isMedia(String type) {
  if (type != "text") {
    return true;
  }
  return false;
}
