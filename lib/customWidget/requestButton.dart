import 'dart:async';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/view/room/provider/room_list_provider.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class RequestButton extends StatefulWidget {
  final Widget child;
  final int userID;
  final bool isRequest;
  final Function onPressed;
  final Function onSuccess;
  final Function onError;
  final double borderRadius;
  final double buttonHeight, buttonWidth;
  final bool setCircle;
  RequestButton(
      {this.userID,
      this.child,
      this.isRequest = false,
      this.onPressed,
      this.onSuccess,
      this.onError,
      this.borderRadius,
      this.buttonHeight,
      this.buttonWidth,
      this.setCircle = false});

  @override
  _RequestButtonState createState() => _RequestButtonState();
}

class _RequestButtonState extends State<RequestButton> with TickerProviderStateMixin {
  int _state = 0;
  AnimationController _progressAnimationController;
  GlobalKey globalKey = GlobalKey();
  Animation _animation;
  RoomsProvider roomsProvider;
  var mutate = GraphQLMutation();
  @override
  void initState() {
    super.initState();
    _progressAnimationController = new AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  Future sendFriendsRequest() async {
    return SubRepo.mutationGraphQL(await getToken(), mutate.sendFriendRequest(widget.userID));
  }

  Future cancelFriendRequest() async {
    return SubRepo.mutationGraphQL(await getToken(), mutate.removeFriendRequest(widget.userID));
  }

  Widget customIcon(IconData icon) {
    return Icon(icon, size: widget.buttonHeight / 2);
  }

  Widget get buttonContent {
    if (widget.isRequest) {
      return customIcon(FeatherIcons.userCheck);
    } else if (_state == 0) {
      return customIcon(FeatherIcons.userPlus);
    } else if (_state == 1) {
      return FutureBuilder(
        future: sendFriendsRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SizedBoxResponsive(
                height: widget.buttonHeight / 2,
                width: widget.buttonHeight / 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: null,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ));
          if (snapshot.hasError) {
            widget.onError("Has error");
            return customIcon(Icons.clear);
          } else {
            var result = snapshot.data;

            widget.onSuccess(1);
            return customIcon(FeatherIcons.userCheck);
          }
        },
      );
    } else if (_state == 2) {
      print("deselect");
      return FutureBuilder(
        future: cancelFriendRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SizedBoxResponsive(
                height: widget.buttonHeight / 2,
                width: widget.buttonHeight / 2,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: null,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ));
          if (snapshot.hasError) {
            widget.onError("Has error");
            return Icon(Icons.clear);
          } else {
            var result = snapshot.data;
            print("deselected");
            widget.onSuccess(2);
            return customIcon(FeatherIcons.userPlus);
          }
        },
      );
    } else {
      return widget.child;
    }
  }

  void animateButton() {
   // print("state is $_state");
    /*_progressAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1).animate(_progressAnimationController)
      ..addListener(() {
        /*setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });*/
      });*/

    //_progressAnimationController.forward();
    if (widget.isRequest) {
      if (mounted) {
        //set to default
        print("is request");
        setState(() {
          _state = 2;
        });
        /* Timer(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _state = 0;
            });
          }
        });*/
      }
    } else if (_state == 1) {
      
      if (mounted) {
        //set to default
       // print("state 2");
        setState(() {
          _state = 2;
        });
        Timer(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _state = 0;
            });
          }
        });
      }
    } else {
      print("state 0");
      // show loading
      if (mounted) {
        setState(() {
          _state = 1;
        });
      }

      // when done
    }
  }

  @override
  Widget build(BuildContext context) {
    roomsProvider = Injector.get(context: context);
    return Container(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: PhysicalModel(
          color: Colors.transparent,
          child: RaisedButton(
            animationDuration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: widget.setCircle
                  ? BorderRadius.circular(10000)
                  : BorderRadius.circular(widget.borderRadius),
            ),
            padding: EdgeInsets.all(0),
            onPressed: () {
              setState(() {
                animateButton();
              });

              return widget.onPressed();
            },
            child: Center(
              child: buttonContent,
            ),
          )),
    );
  }
}
