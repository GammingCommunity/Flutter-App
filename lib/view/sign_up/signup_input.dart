import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:gamming_community/view/sign_up/bloc/bloc/signup_bloc.dart';

class SignUpInput extends StatefulWidget {
  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<SignUpInput> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final backgroundColor = Color(0xff322E2E);
  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final nickname = TextEditingController();
  final repass = TextEditingController();
  final inputStyle = TextStyle(
    fontWeight: FontWeight.w200,
    color: Colors.white,
  );
  FocusNode _email = FocusNode();
  FocusNode _username = FocusNode();
  FocusNode _nickname = FocusNode();
  FocusNode _password = FocusNode();
  FocusNode _retype = FocusNode();

  bool showPwd = true;
  bool showConfirmPwd = true;

  SignUpBloc _signUpBloc;
  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      condition: (prevState, currentState) {
        if (prevState is SignUpLoading) {
          Navigator.pop(context);
        }
        return true;
      },
      listener: (listener, state) {
        if (state is SignUpLoading) {
          return myDialog(context);
        }
        if(state is SignUpSuccess){
          Navigator.of(context).pushNamedAndRemoveUntil('/homepage',(Route<dynamic> route) => false);
          print("Sign up success;");
        }
        if(state is SignUpFailed){
          print("Sign up faild;");
        }
        return null;
      },
      child: BlocBuilder<SignUpBloc, SignUpState>(
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constraint) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Form(
                  autovalidate: true,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        focusNode: _email,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_username);
                        },
                        validator: (String email) {
                          return !Validators.isValidEmail(email)
                              ? "Invaild email"
                              : null;
                        },
                        textInputAction: TextInputAction.next,
                        controller: email,
                        style: inputStyle,
                        decoration: InputDecoration(
                            labelText: "Email (optional)",
                            icon: Icon(Icons.alternate_email),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _username,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_nickname);
                        },
                        textInputAction: TextInputAction.next,
                        style: inputStyle,
                        controller: username,
                        // validator: (String username) {
                        //   return !Validators.isVaildUsername(username)
                        //       ? "Invaild username"
                        //       : null;
                        // },
                        decoration: InputDecoration(
                            labelText: "Username",
                            icon: Icon(Icons.account_circle),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _nickname,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_password);
                        },
                        textInputAction: TextInputAction.next,
                        style: inputStyle,
                        controller: nickname,
                        validator: (String username) {
                          return !Validators.isVaildUsername(username)
                              ? "Invaild username"
                              : null;
                        },
                        decoration: InputDecoration(
                            labelText: "Nick name",
                            icon: Icon(Icons.account_box),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _password,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_retype);
                        },
                        textInputAction: TextInputAction.next,
                        style: inputStyle,
                        controller: password,
                        obscureText: showPwd,
                        validator: (String pass) {
                          return !Validators.isValidPassword(pass)
                              ? "Invaild password"
                              : null;
                        },
                        decoration: InputDecoration(
                            labelText: "Password",
                            icon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                                icon: Icon(showPwd
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  showPwd = !showPwd;
                                }),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        focusNode: _retype,
                        textInputAction: TextInputAction.go,
                        style: inputStyle,
                        controller: repass,
                        obscureText: showConfirmPwd,
                        validator: (_) {
                          if (password.text != repass.text)
                            return 'Password not match';
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Type your password again",
                            icon: Icon(Icons.lock_open),
                            suffixIcon: IconButton(
                                icon: Icon(showConfirmPwd
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    showConfirmPwd = !showConfirmPwd;
                                  });
                                }),
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlineButton(
                          textColor: Colors.white,
                          borderSide: BorderSide(width: 1, color: Colors.white),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(63)),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _signUpBloc.add(Register(
                                  email: email.text,
                                  loginName: nickname.text,
                                  password: password.text,
                                  userName: username.text));
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "SIGN UP",
                                  style: inputStyle,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          });
        },
      ),
    );
  }
}

Future myDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: <Widget>[
            SpinKitCircle(
              color: Colors.white,
              size: 40,
            )
          ],
        );
      });
}
