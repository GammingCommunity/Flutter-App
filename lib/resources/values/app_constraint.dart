import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppConstraint {
  static const double categoryText = 25;
  static const double appBarHeight = 20;
  static const double genre_title_action = 18;
  static const double container_border_radius = 15;
  static const double button_radius = 15;
  static const String sample_proifle_url = "https://via.placeholder.com/150";
  static const String default_profile="https://droncoma.sirv.com/Profile/default_profile.png";
  static SpinKitCubeGrid spinKitCubeGrid =
      SpinKitCubeGrid(color: Colors.white, size: 20);
  static SvgPicture emptyIcon = SvgPicture.asset('assets/icons/empty_logo.svg');
  static const double roomTitleSize = 20;
  static ChewieProgressColors chewieProgressColors = ChewieProgressColors(
    playedColor: Colors.white,
    handleColor: Colors.indigo,
    backgroundColor: Colors.grey,
    bufferedColor: Colors.blueGrey,
  );
  static const double bottom_bar_height= 62;
  
}
