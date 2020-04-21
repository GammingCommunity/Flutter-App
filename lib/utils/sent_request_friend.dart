import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/repository/sub_repo.dart';

class SentRequestFriend extends StatefulWidget {
  final int requestID;
  final String content;
  final double height;
  final double width;
  SentRequestFriend({this.requestID, this.content, this.height, this.width});

  @override
  _ProgressBUttonState createState() => _ProgressBUttonState();
}

class _ProgressBUttonState extends State<SentRequestFriend> with TickerProviderStateMixin {
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  GraphQLMutation mutation = GraphQLMutation();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  Widget setUpChild() {
    if (_state == 0) {
      return Text(
        widget.content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return FutureBuilder(future: Future(() async {
       // SharedPreferences ref = await SharedPreferences.getInstance();
       // var token = ref.getStringList("userToken")[2];
        try {
          return SubRepo.mutationGraphQL("", mutation.sendFriendRequest(widget.requestID));
        } catch (e) {
          return null;
        }
      }), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        else {
          
          if (snapshot.data.data == null) {
            return Icon(Icons.indeterminate_check_box, color: Colors.white);
          } else {
            var result = snapshot.data.data['sendFriendRequest'];
            if (result == false) {
              return Icon(Icons.indeterminate_check_box, color: Colors.white);
            } else
              return Icon(Icons.check, color: Colors.white);
          }
        }
      });
    } else {
      return Icon(Icons.indeterminate_check_box, color: Colors.white);
    }
  }

  void animateButton() {
    //double initialWidth = _globalKey.currentContext.size.width;
    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1).animate(_controller)
      ..addListener(() {
        /*setState(() {
          _width = initialWidth - ((initialWidth - 48) * _animation.value);
        });*/
      });
    _controller.forward();
    if (mounted) {
      setState(() {
        _state = 1;
      });
    }

    Timer(Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _state = 2;
        });
      }
      Timer(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _state = 0;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: widget.height,
        width: widget.width,
        key: _globalKey,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
          padding: EdgeInsets.all(0),
          animationDuration: Duration(milliseconds: 1000),
          onPressed: () {
            setState(() {
              if (_state == 0) {
                animateButton();
              }
            });
          },
          child: setUpChild(),
        ),
      ),
    );
  }
}
