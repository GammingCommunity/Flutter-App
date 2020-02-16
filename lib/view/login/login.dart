import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamming_community/view/login/bloc/bloc/login_bloc.dart';
import 'package:gamming_community/view/login/login_input.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context)=>LoginBloc(),
          child: Scaffold(
          body: DecoratedBox(
            position: DecorationPosition.background,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/test.png"),
                    fit: BoxFit.cover)),
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(left:40,right:40),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                        child: Column(children: <Widget>[
                      Expanded(flex: 2, child: Container()),
                      Expanded(flex: 3, child: LoginInput())
                    ])),
                  ),
                );
              },
            ),
          )),
    );
  }
}
