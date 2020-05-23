import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/models/group_chat_provider.dart';
import 'package:gamming_community/repository/sub_repo.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/get_token.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class DisplayMember extends StatefulWidget {
  final List ids;
  final double borderRadius;
  final double size;
  final Function onTap;
  final bool clickable;
  final bool showBadged;
  DisplayMember(
      {@required this.ids,
      @required this.borderRadius,
      @required this.size,
      this.onTap,
      this.clickable = false,
      this.showBadged = false});
  @override
  _DisplayMemberState createState() => _DisplayMemberState();
}

class _DisplayMemberState extends State<DisplayMember> with AutomaticKeepAliveClientMixin {
  var query = GraphQLQuery();
  String currentID = "";
  GroupChatProvider _groupChatProvider;
  @override
  void initState() {
    super.initState();
    getCurrentID().then((value) => {
          print("here $value"),
          setState(() {
            currentID = value;
          })
        });
  }

  Future getCurrentID() async {
    var info = await getUserInfo();
    return info['userID'];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _groupChatProvider = Injector.get();
    return FutureBuilder<List<User>>(
      future: Future(() async {
        // convert to list int
        var listInt = List<int>.from(widget.ids.map((e) => int.parse(e)).toList());
        var getUsers = <User>[];
        try {
          var result = await SubRepo.queryGraphQL(await getToken(), query.getUserInfo(listInt));
          getUsers = ListUser.fromJson(result.data['lookAccount']).listUser;
          
        } catch (e) {
          print(e);
          return [];
        }
        return getUsers;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoading(context, widget.size);
        } else {
          var users = snapshot.data;
          //print(currentID == "68");
          return users.isEmpty
              ? Text("Error")
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var item in users)
                      Stack(
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            onTap: () {
                              widget.clickable ? widget.onTap() : null;
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                              child: CachedNetworkImage(
                                imageUrl: item.profileUrl ?? AppConstraint.default_profile,
                                height: widget.size,
                                width: widget.size,
                                fit: BoxFit.cover,
                                placeholder: (context, image) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(widget.borderRadius)),
                                ),
                                errorWidget: (context, error, image) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          widget.showBadged ?? currentID == item.id
                              ? Positioned(
                                  bottom: -4,
                                  right: -3,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ))
                              : Container(
                                  height: 10,
                                  width: 10,
                                ),
                        ],
                      ),
                  ],
                );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget buildLoading(BuildContext context, double size) {
  return Container(
      height: size,
      width: size,
      child: Center(child: SpinKitCubeGrid(color: Theme.of(context).iconTheme.color, size: 10)));
}
