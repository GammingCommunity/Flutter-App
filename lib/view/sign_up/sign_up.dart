import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamming_community/view/sign_up/bloc/bloc/signup_bloc.dart';
import 'package:gamming_community/view/sign_up/signup_header.dart';
import 'package:gamming_community/view/sign_up/signup_input.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final backgroundColor = Color(0xff322E2E);
  final titleScreen = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(),
        child: Scaffold(
            body: Container(
          height: screenSize.height,
          child: Column(children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: backgroundColor,
                child: Header(),
              ),
            ),
            Expanded(
                flex: 2,
                child: Container(color: backgroundColor, child: SignUpInput()))
          ]),
        )));
  }
}
