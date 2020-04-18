import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/API/config/mainAuth.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ListUserDrawer extends StatefulWidget {
  final String token;
  final String chatID;
  ListUserDrawer({this.token, this.chatID});
  @override
  _ListUserDrawerState createState() => _ListUserDrawerState();
}

class _ListUserDrawerState extends State<ListUserDrawer> with AutomaticKeepAliveClientMixin {
  final double drawerWidth = 200;
  GraphQLQuery query = GraphQLQuery();
  var alignment = Alignment.center;

  @override
  void initState() {
    super.initState();
    print(widget.chatID);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    super.build(context);
    return SizedBox(
      width: drawerWidth,
      height: screenSize.height,
      child: Drawer(
          child: GraphQLProvider(
            key: PageStorageKey<String>('pagestore'),
        client: customClient(widget.token),
        child: CacheProvider(
          child: Container(
            padding: EdgeInsets.only(top: 20, left: 10),
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "List User",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                SizedBox(height: 50),
                Query(
                  options: QueryOptions(documentNode: gql(query.getPrivateChatInfo(widget.chatID))),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.loading) {
                      return Container(
                        alignment: Alignment.center,
                        child: AppConstraint.spinKitCubeGrid(context),
                      );
                    }
                    if (result.hasException) {
                      return AppConstraint.noImage;
                    } else {
                      return Container(
                        height: screenSize.height - 40,
                        padding: EdgeInsets.all(10),
                        width: drawerWidth,
                        alignment: Alignment.topCenter,
                        constraints: BoxConstraints.tight(Size.fromHeight(screenSize.width)),
                        child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(height: 20),
                            itemCount: 2,
                            itemBuilder: (context, index) => Container(
                                  height: 50,
                                  width: drawerWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      // Image
                                      CachedNetworkImage(imageUrl: AppConstraint.default_profile),
                                      SizedBox(width: 20),

                                      Text("Name")

                                      // name
                                    ],
                                  ),
                                )),
                      );
                    }
                  },
                )

                /*FutureBuilder(
                  future: Future(() async {
                    return MainRepo.queryGraphQL(
                          widget.token, query.getPrivateChatInfo(widget.chatID));

                    //var userIDResult = await SubRepo.queryGraphQL(widget.token, query.getUserInfo())
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          alignment: Alignment.center,
                          child: AppConstraint.spinKitCubeGrid,
                        );
                    } else {
                        // set list to top center
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          alignment = Alignment.topCenter;
                        });
                        // get info here
                        var result = snapshot.data.data;

                        return Container(
                          height: screenSize.height -40,
                          padding: EdgeInsets.all(10),
                          width: drawerWidth,
                          constraints: BoxConstraints.tight(Size.fromHeight(screenSize.width)),
                          child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(height: 20),
                              itemCount: 2,
                              itemBuilder: (context, index) => Container(
                                    height: 50,
                                    width: drawerWidth,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        // Image
                                        CachedNetworkImage(imageUrl: AppConstraint.default_profile),
                                        SizedBox(width: 20),

                                        Text("Name")

                                        // name
                                      ],
                                    ),
                                  )),
                        );
                    }
                  },
                ),*/
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
