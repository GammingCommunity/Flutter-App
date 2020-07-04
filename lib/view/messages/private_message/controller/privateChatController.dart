import 'package:flutter/material.dart';
import 'package:frefresh/frefresh.dart';
import 'package:gamming_community/view/messages/models/private_chat_provider.dart';
import 'package:get/get.dart';

class PrivateChatController extends GetxController{
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String roomName = "Sample here";
  bool isSubmited = false;
  ScrollController _scrollController;
  AnimationController animationController;
  PrivateChatProvider _privateChatProvider;
  FRefreshController controller;

  String text = "Drop-down to loading";
}