import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/imageHover.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/color_utility.dart';
import 'package:gamming_community/view/feeds/provider/feedsProvider.dart';
import 'package:gamming_community/view/user_post/content_widget/imageContent.dart';
import 'package:gamming_community/view/user_post/post_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class UserPost extends StatefulWidget {
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  TextEditingController txtContent = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  PostProvider postProvider;
  FeedsProvider feedsProvider;
  ScrollController imageGalery;
 // MethodChannel _channel = const MethodChannel('image_gallery');

  bool isContentEmpty = true;
  bool selected = true;
  bool isKeyboardShowing = false;

  @override
  void initState() {
    imageGalery = ScrollController()
      ..addListener(() async {
        if (imageGalery.position.pixels == imageGalery.position.maxScrollExtent) {
          // load more
          await postProvider.loadMoreImage();
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await postProvider.initImageGalery();
      isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    });
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('All your progress will be delete ?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    postProvider = Injector.get();
    isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;
    feedsProvider = Injector.get();
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: CustomAppBar(
            child: [
              Spacer(),
              RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: isContentEmpty
                    ? null
                    : () async {
                        //List result = await FileUploadRepo.getMediaUpload(postProvider.postContent);
                        //print(result);
                        if (isContentEmpty) {
                          return BotToast.showText(text: "Content must not empty.");
                        } else {
                          try {
                            var result = await feedsProvider
                                .addPost(await postProvider.post(txtContent.text));
                            Get.dialog(Center(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(),
                              ),
                            ));
                            if (result) {
                              BotToast.showText(text: "Create post success");
                              Get.offAndToNamed("homepage");
                            }
                            Get.back();
                          } catch (e) {
                            print(e);
                            return BotToast.showText(text: "Try again");
                          }
                        }
                      },
                child: Text("Post"),
              )
            ],
            height: 50,
            onNavigateOut: () async {
              await _onWillPop();
              postProvider.clear();
              Get.back();
            },
            padding: EdgeInsets.only(right: 10),
            backIcon: FeatherIcons.x),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // avatar
                      CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageBuilder: (context, imageProvider) => Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: imageProvider)),
                              ),
                          imageUrl: AppConstraint.default_profile),
                      SizedBox(width: 10),
                      Container(
                        height: 100,
                        width: Get.width - 80,
                        child: TextField(
                          controller: txtContent,
                          maxLines: 3,
                          onChanged: (value) {
                            if (txtContent.text == "")
                              setState(() {
                                isContentEmpty = true;
                              });

                            setState(() {
                              isContentEmpty = false;
                            });
                          },
                          decoration: InputDecoration.collapsed(
                              hintText: "Your content here", border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // image area
              Flexible(
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: postProvider.postCotentLength,
                  itemBuilder: (context, index) {
                    return ImageContent(
                      onClick: () {
                        Get.dialog(previewImage(postProvider.postContent[index].file));
                      },
                      onRemove: () {
                        postProvider.removeFromPostContent(index);
                      },
                      file: postProvider.postContent[index].file,
                      imageHeight: postProvider.postContent[index].height,
                      imageWidth: postProvider.postContent[index].width,
                    );
                  },
                ),
              ),
              Spacer(),
              SizedBox(height: 10),
              // load image from device
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                alignment: Alignment.topRight,
                height: isKeyboardShowing ? 0 : 150,
                width: Get.width,
                child: Column(
                  children: [
                    Visibility(
                      visible: postProvider.images.isNotEmpty,
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 40,
                            width: 100,
                            child: RaisedButton(
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                onPressed: () async {
                                  // add all post for preview and hide image
                                  isKeyboardShowing = false;
                                  await postProvider.addAllChooseImage();
                                },
                                child: Text("Done ( ${postProvider.images.length.toString()} ) ")),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(width: 5),
                        addAutomaticKeepAlives: true,
                        controller: imageGalery,
                        scrollDirection: Axis.horizontal,
                        itemCount: postProvider.getImageGalery.length,
                        itemBuilder: (context, index) {
                          var images = postProvider.getImageGalery;
                          return Container(
                              height: 100,
                              width: 100,
                              child: ImageHover(
                                  file: images[index],
                                  onClick: () async {
                                    // display image

                                    Get.dialog(previewImage(images[index]));
                                  },
                                  onLongPress: (File file) {
                                    print(file == null);
                                    file == null
                                        ? postProvider.deselectImage(index)
                                        : postProvider.selectImage(index, file);
                                  }));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: Get.width,
                  padding: EdgeInsets.all(5),
                  color: brighten(AppColors.BACKGROUND_COLOR, 4),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircleIcon(
                              toolTip: "Image",
                              icon: FeatherIcons.image,
                              onTap: () async {
                                var image = await imagePicker.getImage(source: ImageSource.gallery);
                                //close modal

                                //print(image);
                                try {
                                  //getImage.setFilePath(image);
                                  await postProvider.addPickImage(File(image.path));
                                } catch (e) {}
                              }),
                          CircleIcon(
                              toolTip: "Video",
                              icon: FeatherIcons.video,
                              onTap: () async {
                                var result = await PhotoManager.requestPermission();
                                if (result) {
                                  // success
                                  // await getAllImages();
                                } else {
                                  // fail
                                  /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
                                }
                              }),
                          CircleIcon(toolTip: "Gif", icon: FeatherIcons.save, onTap: () {}),
                          CircleIcon(toolTip: "Poll", icon: FeatherIcons.menu, onTap: () {}),
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Widget previewImage(File file) {
  return Scaffold(
      appBar: CustomAppBar(
          child: [],
          height: 40,
          onNavigateOut: () {
            Get.back();
          },
          padding: EdgeInsets.only(right: 10),
          backIcon: FeatherIcons.x),
      body: Container(
          width: Get.width,
          height: Get.height,
          color: AppColors.BACKGROUND_COLOR,
          child: Image.file(file)));
}
