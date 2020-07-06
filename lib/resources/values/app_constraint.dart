import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/customWidget/loading.dart';
import 'package:gamming_community/view/profile/profileController.dart';

class AppConstraint {
  static const double categoryText = 25;
  static const double appBarHeight = 20;
  static const double genre_title_action = 18;
  static const double container_border_radius = 15;
  static const double button_radius = 15;
  static const String sample_proifle_url = "https://via.placeholder.com/150";
  static const String default_profile =
      "https://cdn.image4.io/mattstacey/f_auto/57882dae-888d-4c43-9dc5-924ae05b332c.png";
  static const String default_cover =
      "https://res.cloudinary.com/mattstacey/image/upload/v1594053062/background/ylf1fv0w5zyr0jfqv8dx.png";
  static const String default_logo = "https://cdn.image4.io/mattstacey/f_auto/avatar/c3dfa8d0-bb49-4da7-a3fa-c26d7c3f9123.png";
  static const String default_background =
      "https://droncoma.sirv.com/default_background/no_image.png";
  static Image noImage = Image.asset('assets/images/no_image.png');
  static Widget spinKitCubeGrid(context) =>
      SpinKitCubeGrid(color: Theme.of(context).iconTheme.color, size: 20);

  static Widget loadingIndicator(BuildContext context, [double size = 50]) {

    return ProfileController.to.darkTheme
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
