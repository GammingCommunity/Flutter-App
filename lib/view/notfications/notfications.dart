import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Subscription.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/customWidget/circleIcon.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Notfications extends StatefulWidget {
  @override
  _NotficationsState createState() => _NotficationsState();
}

class _NotficationsState extends State<Notfications> {
  GqlSubscription subscription = GqlSubscription();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(child: Row(children: <Widget>[
        CircleIcon(
          icon: FeatherIcons.chevronLeft,
          iconSize: 20,
          onTap: (){
            Navigator.pop(context);

          },
        ),

      ],), preferredSize: Size.fromHeight(40)),
      body: GraphQLProvider(
        client: customClient(""),
        child: CacheProvider(
          child: Scaffold(
            body: Container(
              height: screenSize.height,
              width: screenSize.width,
              child: Subscription(
                "",
                subscription.onJoinRoom(),
                builder: ({error, loading, payload}) {
                  return Center(
                    child: Text("Notfication"),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
