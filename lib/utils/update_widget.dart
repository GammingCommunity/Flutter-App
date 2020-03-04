import 'package:flutter/material.dart';
import 'package:gamming_community/API/Auth.dart';
import 'package:gamming_community/API/Mutation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateWidget extends StatefulWidget {
  final String token;
  final String nickname, email, phone, describe, birthday;
  UpdateWidget(
      {this.token,
      this.nickname,
      this.email,
      this.phone,
      this.describe,
      this.birthday});

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  GraphQLMutation mutation =GraphQLMutation();

  Future update() async {
    GraphQLClient client = authAPI(widget.token);
    //TODO: update profile data
    /*var result = await client.mutate(MutationOptions(
        documentNode: gql(mutation.editAccount(
            widget.nickname, widget.describe, widget.email, "", ""))));*/
    
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
            future: update(),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    value: null,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }
              else return Icon(Icons.check, color: Colors.white);
            });
  }
}