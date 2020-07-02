import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/customWidget/loading.dart';
import 'package:gamming_community/view/profile/profileController.dart';
import 'package:get/get.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AppConstraint {
  static const double categoryText = 25;
  static const double appBarHeight = 20;
  static const double genre_title_action = 18;
  static const double container_border_radius = 15;
  static const double button_radius = 15;
  static const String sample_proifle_url = "https://via.placeholder.com/150";
  static const String default_profile =
      "https://cdn.image4.io/mattstacey/f_auto/57882dae-888d-4c43-9dc5-924ae05b332c.png?fbclid=IwAR2H1LEHlXceQAFJR-BH6RR3R74KuAQRP6y7JYnIosZbxcKJshLZaaLDwQc";
  static const String default_cover =
      "https://cdn.image4.io/mattstacey/f_auto/cover/9df0a69a-209d-468f-8171-51c8417eabe0.png?fbclid=IwAR2AgwDy1WnneW8iZqlP6POxdMkDQaRzqrpau4ihn1p_QsBT5uNgfT-6bn4";
  static const String default_logo = "https://droncoma.sirv.com/Logo/logo.png";
  static const String default_background =
      "https://droncoma.sirv.com/default_background/no_image.png";
  static Image noImage = Image.asset('assets/images/no_image.png');
  static Widget spinKitCubeGrid(context) =>
      SpinKitCubeGrid(color: Theme.of(context).iconTheme.color, size: 20);

  static Widget loadingIndicator(BuildContext context, [double size = 50]) {

    return ProfileController.to.darkTheme.value
        ? CustomLoadingIndicator(darkMode: true, size: size)
        : CustomLoadingIndicator(darkMode: false, size: size);
  }

  static SvgPicture emptyIcon = SvgPicture.asset('assets/icons/empty_logo.svg');
  static const double roomTitleSize = 20;
  static ChewieProgressColors chewieProgressColors = ChewieProgressColors(
    playedColor: Colors.white,
    handleColor: Colors.indigo,
    backgroundColor: Colors.grey,
    bufferedColor: Colors.blueGrey,
  );
  static const double bottom_bar_height = 62;
  static const String noImageAsset = "assets/images/no_image.png";
  static const TextStyle textAppbar = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}
