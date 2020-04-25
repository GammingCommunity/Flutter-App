import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/subAuth.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/sent_request_friend.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

Future showFriendProfile(BuildContext context, String token, int userID) {
  GraphQLQuery query = GraphQLQuery();
  var buttonHeight = ButtonTheme.of(context).height;
  var buttonWidth = ButtonTheme.of(context).minWidth + 10;
  return showDialog(
    useRootNavigator: true,
    barrierDismissible: true,
    context: context,
    builder: (context) => Center(
      child: Material(
        borderRadius: BorderRadius.circular(15),
        child: ContainerResponsive(
            height: 200.h,
            width: 350.w,
            decoration:
                BoxDecoration(color: Color(0xff252525), borderRadius: BorderRadius.circular(15)),
            child: GraphQLProvider(
              client: customSubClient(token),
              child: CacheProvider(
                  child: Query(
                options: QueryOptions(documentNode: gql(query.getUserInfo([userID]))),
                builder: (result, {fetchMore, refetch}) {
                  if (result.loading) {
                    // sketlon loading
                    return Stack(
                      alignment: Alignment.center,
                      fit: StackFit.loose,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Color(0xff252525), borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        Positioned(
                            left: 30,
                            top: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10000),
                                child: Container(height: 100, width: 100, color: Colors.grey),
                              ),
                            )),
                        Positioned.fill(
                            top: 40,
                            left: 30,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 100,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      height: 20,
                                      width: 100,
                                      color: Colors.grey,
                                    ),
                                    SizedBoxResponsive(height:20),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.grey),
                                      width: buttonWidth,
                                      height: buttonHeight,
                                    )
                                  ],
                                ))),

                      ],
                    );
                  } else {
                    return Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: Color(0xff252525), borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        Positioned(
                            left: 30,
                            top: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10000),
                                child: CachedNetworkImage(
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    imageUrl: AppConstraint.sample_proifle_url),
                              ),
                            )),
                        Positioned.fill(
                            top: 40,
                            left: 50,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Mattstacey",
                                      style: TextStyle(fontSize: 25, color: Colors.white)),
                                  SizedBox(height: 5),
                                  Text("@nickname",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: "ProductSans-Light")),
                                ],
                              ),
                            )),
                        Positioned.fill(
                          top: 70,
                          left: 30,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                child: SentRequestFriend(
                              width: buttonWidth,
                              height: buttonHeight,
                              requestID: 100,
                              content: "Add friend",
                            )),
                          ),
                        )
                      ],
                    );
                  }
                },
              )),
            )),
      ),
    ),
  );
}
