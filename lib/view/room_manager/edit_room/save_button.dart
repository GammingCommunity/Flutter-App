import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:gamming_community/utils/uploadFile.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class SaveButton extends StatefulWidget {
  //TODO: error on update

  SaveButton();

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> with TickerProviderStateMixin {
  int _state = 0;
  Animation _animation;
  AnimationController _controller;
  GlobalKey _globalKey = GlobalKey();
  GraphQLMutation mutation = GraphQLMutation();
  EditRoomProvider provider;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  Widget setUpChild() {
    if (_state == 0) {
      return Text(
        "Save",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (_state == 1) {
      return FutureBuilder(future: Future(() async {
        return provider.save();
      }), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        else {
         
          try {
            if (snapshot.data.data['editRoom']['status'] == 200) {
              return Icon(Icons.check, color: Colors.white);
            }
          } catch (e) {
            return Icon(Icons.clear, color: Colors.white);
          }
          return Icon(Icons.clear, color: Colors.white);

          //return Icon(Icons.check, color: Colors.white);
        }
      });
    } else {
      return Icon(Icons.check, color: Colors.white);
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
    provider = Injector.get(context: context);
    return PhysicalModel(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 30,
        key: _globalKey,
        child: AbsorbPointer(
          absorbing: provider.isLoading ? true : false,
          child: RaisedButton(
            color: provider.isLoading ? Colors.grey : Colors.indigo,
            
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
      ),
    );
  }
}
