import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamming_community/view/login/controller/loginController.dart';
import 'package:get/get.dart';

class LoginInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put<LoginController>(LoginController());
    return GetBuilder<LoginController>(
        builder: (_) => GetX<LoginController>(
              builder: (l) => Form(
                  autovalidate: false,
                  key: l.formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        focusNode: l.usernameFocus,
                        textInputAction: TextInputAction.next,
                        validator: (text) => l.validateUsername(text),
                        onFieldSubmitted: (String val) => l.nextFocus(context, l.passwordFocus),
                        onChanged: (String val) => l.isAllValidate(),
                        controller: l.usernameCtrl,
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
                          focusNode: l.passwordFocus,
                          textInputAction: TextInputAction.go,
                          validator: (String text) => l.validatePassword(text),
                          controller: l.passwordCtrl,
                          onChanged: (value) => l.isAllValidate(),
                          obscureText: l.showPwd,
                          onFieldSubmitted: (String val) {
                            //FocusScope.of(context).requestFocus(_loginButton);
                            return l.nextFocus(context, l.loginButtonFocus);
                          },
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(l.showPwd ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => l.hidePwd),
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
                          focusNode: l.loginButtonFocus,
                          onPressed: () async{
                            // login here
                            await l.login(context);
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(fontSize: 15),
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
                            Get.toNamed('/forgot');
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
                                          //loginBloc.add(LoginWithSocial());
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
                                          Get.toNamed('/signup');
                                        },
                                        child: Text(" Sign up now",
                                            style: TextStyle(
                                                fontSize: 15, fontWeight: FontWeight.bold)),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                    ],
                  )),
            ));
  }
}
/*
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
    username.text = "jojo195";
    password.text = "hoanglee1998";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
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

          Get.offAllNamed("/homepage");
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil("/homepage", (Route<dynamic> route) => false);
        }
        if (state is LoginFailed) {
          Get.snackbar(
            "Forgot your email or username",
            "Press here",
            onTap: (snack) {
              Get.to(ForgotPassword());
            },
            duration: Duration(seconds: 5),
            isDismissible: true,
          );
          /* Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Forgot your email or username "),
            action: SnackBarAction(
                label: "Press here",
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                }),
          ));*/
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
                    return !Validators.isVaildUsername(username.text) ? 'Invalid Username' : null;
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
                      return !Validators.isValidPassword(text) ? "Invaild password" : null;
                    },
                    controller: password,
                    obscureText: showPwd,
                    onFieldSubmitted: (String val) {
                      if (_formKey.currentState.validate()) {
                        loginBloc.add(Submited(email: username.text, password: password.text));
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
                          icon: Icon(showPwd ? Icons.visibility : Icons.visibility_off),
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
                        loginBloc.add(Submited(email: username.text, password: password.text));
                      }

                      //Navigator.of(context).pushNamed('/homepage');
                    },
                    //borderSide: BorderSide(color: Colors.white, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      Get.toNamed('/forgot');
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
                                    Get.toNamed('/signup');
                                  },
                                  child: Text(" Sign up now",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          children: <Widget>[
            SpinKitCircle(
              color: Colors.white,
              size: 40,
            )
          ],
        );
      });
}
*/
