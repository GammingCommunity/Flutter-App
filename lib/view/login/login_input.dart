import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:gamming_community/view/forgot_password/forgotPassword.dart';
import 'package:gamming_community/view/login/bloc/bloc/login_bloc.dart';

class LoginInput extends StatefulWidget {
  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _loginButton = FocusNode();
  bool loginButton = false;
  bool showPwd = true;
  final style = TextStyle(
    fontWeight: FontWeight.w200,
    color: Colors.white,
  );
  LoginBloc loginBloc;
  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    username.text="jojo195";
    password.text="hoanglee1998";
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      bloc: loginBloc,
      condition: (prevState, currentState) {
        if (prevState is LoginLoading) {
          Navigator.pop(context);
        }
        return true;
      },
      listener: (listenerContext, state) {
        if (state is LoginLoading) {
          myDialog(listenerContext);
        }
        if (state is LoginSuccess) {
          //Navigator.pop(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/homepage", (Route<dynamic> route) => false);
        }
        if (state is LoginFailed) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Forgot your email or username "),
            action: SnackBarAction(
                label: "Press here",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForgotPassword()));
                }),
          ));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: _usernameFocus,
                  textInputAction: TextInputAction.next,
                  validator: (text) {
                    return !Validators.isVaildUsername(username.text)
                        ? 'Invalid Username'
                        : null;
                  },
                  onFieldSubmitted: (String val) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  onChanged: (String val) {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loginButton = true;
                      });
                    }
                  },
                  controller: username,
                  style: style,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.alternate_email,
                      color: Colors.white,
                      size: 20,
                    ),
                    labelText: 'Your username or email',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.go,
                    validator: (String text) {
                     // print(text);
                      return !Validators.isValidPassword(text)
                          ? "Invaild password"
                          : null;
                    },
                    controller: password,
                    obscureText: showPwd,
                    onFieldSubmitted: (String val) {
                      if (_formKey.currentState.validate()) {
                        loginBloc.add(Submited(
                            email: username.text, password: password.text));
                      }
                      FocusScope.of(context).requestFocus(_loginButton);
                    },
                    style: style,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(showPwd
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            showPwd = !showPwd;
                          }),
                      labelText: 'Your password',
                      labelStyle: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width,
                  buttonColor: Colors.indigo,
                  child: RaisedButton(
                    focusNode: _loginButton,
                    onPressed: () {
                     if (_formKey.currentState.validate()) {
                        loginBloc.add(Submited(
                            email: username.text, password: password.text));
                      }

                      //Navigator.of(context).pushNamed('/homepage');
                    },
                    //borderSide: BorderSide(color: Colors.white, width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Sign in",
                            style: style,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/forgot');
                    },
                    splashColor: Colors.transparent,
                    child: Text("Forgot password ?"),
                  ),
                ),
                Spacer(),
                Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/google_logo.svg",
                                    height: 25,
                                    width: 21,
                                  ),
                                  onPressed: () {
                                    loginBloc.add(LoginWithSocial());
                                    //Navigator.of(context).pushNamed("/profile");
                                  }),
                              IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/icons/fb_logo.svg",
                                    height: 25,
                                    width: 21,
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have account ?"),
                              Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/signup");
                                  },
                                  child: Text(" Sign up now",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ));
      }),
    );
  }
}

Future myDialog(BuildContext context) {
  return showDialog(
    useRootNavigator: true,
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

