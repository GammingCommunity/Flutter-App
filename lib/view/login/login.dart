import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/customWidget/faslideAnimation.dart';
import 'package:gamming_community/view/login/bloc/bloc/login_bloc.dart';
import 'package:gamming_community/view/login/login_input.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                      child: Column(children: <Widget>[
                    FaSlideAnimation(
                      show: true,
                      delayed: 200,
                      child: Expanded(
                          flex: 2,
                          child: Container(
                            height: 200,
                            width: 200,
                            child: SvgPicture.asset('assets/icons/logo/brand.svg'),
                          )),
                    ),
                    FaSlideAnimation(
                      show: true,
                      delayed: 200,
                      child: Expanded(flex: 3, child: LoginInput()))
                  ])),
                ),
              );
            },
          ),
        ));
  }
}
