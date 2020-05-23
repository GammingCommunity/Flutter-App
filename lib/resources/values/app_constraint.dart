import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/utils/brighness_query.dart';
import 'package:gamming_community/customWidget/loading.dart';
import 'package:gamming_community/view/profile/settingProvider.dart';
import 'package:provider/provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AppConstraint {
  static const double categoryText = 25;
  static const double appBarHeight = 20;
  static const double genre_title_action = 18;
  static const double container_border_radius = 15;
  static const double button_radius = 15;
  static const String sample_proifle_url = "https://via.placeholder.com/150";
  static const String default_profile = "https://droncoma.sirv.com/Profile/default_profile.png";
  static const String default_logo = "https://droncoma.sirv.com/Logo/logo.png";
  static const String default_background =
      "https://droncoma.sirv.com/default_background/no_image.png";
  static Image noImage = Image.asset('assets/images/no_image.png');
  static Widget spinKitCubeGrid(context) =>
      SpinKitCubeGrid(color: Theme.of(context).iconTheme.color, size: 20);

  static Widget loadingIndicator(BuildContext context,[double size = 50]) {
    SettingProvider settingProvider = Injector.get(context: context);

    return settingProvider.darkTheme
        ? CustomLoadingIndicator(darkMode: true,size:size)
        : CustomLoadingIndicator(darkMode: false,size:size);
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
  static const int searchBackground = 0xff5a5757;
  static const String noImageAsset = "assets/images/no_image.png";
  static const TextStyle textAppbar = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
}
