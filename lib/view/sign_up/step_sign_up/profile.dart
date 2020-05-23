import 'package:flutter/material.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        children: <Widget>[
          // avatar here

          ButtonTheme(
              minWidth: 200,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  // check user wanna verify account or not

                  // if not, skip and process create account
                  pageProvider.createAccount();
                },
                child: Text("Create Account"),
              ))
        ],
      ),
    );
  }
}
