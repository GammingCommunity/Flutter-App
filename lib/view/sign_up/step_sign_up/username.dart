
import 'package:flutter/material.dart';
import 'package:gamming_community/utils/validators.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:provider/provider.dart';

class UserName extends StatefulWidget {
  final PageController controller;
  UserName({this.controller});
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> with AutomaticKeepAliveClientMixin {
  var userNameController = TextEditingController();
  bool hasError = false;
  bool get isEmpty => userNameController.text == "";
  String get userName => userNameController.text;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: screenSize.height,
            width: screenSize.width,
            child: Column(children: <Widget>[
              Text(
                "How we can call you ? ",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: TextField(
                  controller: userNameController,
                  onChanged: (value) {
                    if (Validators.isVaildUsername(value)) {
                      setState(() {
                        hasError = false;
                      });
                      return;
                    } else {
                      setState(() {
                        hasError = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Tell me your username",
                    errorText: hasError ? "Username not vaild " : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Note: Username limit to 8 characters.")),
              SizedBox(
                height: 20,
              ),
              ButtonTheme(
                  minWidth: 200,
                  height: 50,
                  child: RaisedButton(
                    onPressed: isEmpty
                        ? null
                        : () {
                            pageProvider.setPageIndex(3);
                            pageProvider.setUsername(userName);
                            widget.controller.animateToPage(3,
                                duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                          },
                    child: Text("Next"),
                  ))
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}
